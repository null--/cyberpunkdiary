class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find( params[:id] )
    @total = @tag.articles.count

    @perpage = 6
    @page = (params[:page] || '1').to_i;

    @articles = @tag.articles.find(:all, :order => "created_at desc", :limit => @perpage, :offset => (@page - 1) * @perpage);

    @n_page = @total / @perpage;
    @n_page = @n_page + 1 if @n_page * @perpage != @total
  end
  
  def tag_rss
    tag = Tag.find( params[:id] )
    if !tag.nil? then
      articles = tag.articles.find(:all, :order => "created_at desc", :limit => 22, :offset => 0);
    
      generate_rss(articles,
                   'Latest articles tagged as ' + tag.name, 
                   Proc.new {|art| art.title}, 
                   Proc.new {|art| art.abstract}, 
                   Proc.new {|art| 'http://' + request.host + ':' + request.port.to_s + '/articles/' + art.id.to_s})
    end
  end
end
