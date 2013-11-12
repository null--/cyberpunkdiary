include ERB::Util
require 'digest/md5'

class ArticlesController < ApplicationController
  def validate_params
    # params[:article][:body] = params[:article][:body].gsub(/(?:\n\r?|\r\n?)/, '<br>')

    # params.require(:article).permit(:title, :abstract, :body)
    # params.require(:article).permit(:title, :abstract, :body)
    if not params[:article] or 
        not params[:article][:title] or 
        not params[:article][:body]
    then
      # => TODO: fail is not cool!
      fail
    end

    # => TODO: SQLi, XSS Validation    
    { 
      :title => params[:article][:title], 
      :abstract => params[:article][:abstract],
      :body => params[:article][:body],
      :tag_list => params[:article][:tag_list]
    }
  end

  def index
    @perpage = 9

    @page = (params[:page] || '1').to_i;
    @total = Article.count

    @dir = 'desc'
    @dir = 'asc' if params[:dir] == 'asc'

    @order = 'created_at'
    @order = 'leet' if params[:order] == 'leet'
    @order = 'lame' if params[:order] == 'lame'
    @order = 'hits' if params[:order] == 'hits'
    @order = 'title' if params[:order] == 'title'

    @articles = Article.find(:all, :order => (@order + " " + @dir), :limit => @perpage, :offset => (@page - 1) * @perpage);

    # less words! :D
    @order = 'date' if @order == 'created_at'

    @n_page = @total / @perpage;
    @n_page = @n_page + 1 if @n_page * @perpage != @total
  end

  def show
    @article = Article.find( params[:id] )
    
    @article.hits = @article.hits + 1
    @article.save

    @comment = Comment.new
    @comment.article_id = @article.id
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find( params[:id] )
  end

  def create
    # @article = Article.new

    # @article.title = params[:article][:title]
    # @article.abstract = params[:article][:abstract]
    # @article.body = params[:article][:body]
    
    @article = Article.new( validate_params )
    
    u = User.get_current_user session
    
    if u then # and u.id == @article.user_id then
      @article.user_id = u.id
      @article.icon = params[:article][:icon] || 0
      @article.save

      redirect_to_article
    else
      redirect_to_index_error
    end
  end

  def update
    @article = Article.find( params[:id] )

    u = User.get_current_user session

    if u and (u.id == @article.user_id || u.priv == 10) then
      @article.update_attributes( validate_params )
      @article.icon = params[:article][:icon] || 0
      @article.save
      flash[:notice] = "Hey #{u.nickname}, '#{@article.title}' has been updated."
      redirect_to_article
    else
      redirect_to_index_error
    end
  end

  def destroy
    @article = Article.find( params[:id] )
    @article.destroy

    redirect_to_index
  end
  
  def diary_rss
    articles = Article.find(:all, :order => "created_at desc", :limit => 22, :offset => 0);
    generate_rss(articles,
                 'Cyberpunkdiary: 1337 or lame', 
                 Proc.new {|art| art.title}, 
                 Proc.new {|art| art.abstract}, 
                 Proc.new {|art| 'http://' + request.host + ':' + request.port.to_s + '/articles/' + art.id.to_s})
  end
  
  def comment_rss
    article = Article.find( params[:id] )
    comments = article.comments[0..22]
    
    generate_rss(comments,
                 'Latest comments of ' + article.title, 
                 Proc.new {|cmn| cmn.user.nickname}, 
                 Proc.new {|cmn| cmn.body}, 
                 Proc.new {'http://' + request.host + ':' + request.port.to_s + '/articles/' + article.id.to_s})
  end
end
