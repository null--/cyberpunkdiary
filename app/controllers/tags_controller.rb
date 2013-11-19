class TagsController < ApplicationController
  def index
    @tags = Tag.all
    @total_art = Article.count
    
  rescue => details
    general_rescue details
  end

  def show
    @tag = Tag.find( params[:id] )
    @total = @tag.articles.count

    @perpage = CPDConf.tag_perp
    @page = (params[:page] || '1').to_i;

    @articles = @tag.articles.find(:all, :order => "created_at desc", :limit => @perpage, :offset => (@page - 1) * @perpage);

    @n_page = @total / @perpage;
    @n_page = @n_page + 1 if @n_page * @perpage != @total
    
  rescue => details
    general_rescue details
  end
  
  def tag_rss
    tag = Tag.find( params[:id] )
    if !tag.nil? then
      articles = tag.articles.find(:all, :order => "created_at desc", :limit => 22, :offset => 0);
    
      generate_rss(articles,
                   CPDConf.tag_rss_title(tag.name), 
                   Proc.new {|art| art.title}, 
                   Proc.new {|art| art.abstract}, 
                   Proc.new {|art| 'http://' + request.host + ':' + request.port.to_s + '/articles/' + art.id.to_s})
    end
  rescue => details
    general_rescue details
  end
end
