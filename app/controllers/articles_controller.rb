class ArticlesController < ApplicationController
  def validate_params
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
    @articles = Article.all
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
      @article.save

      redirect_to_article
    else
      redirect_to_index_error
    end
  end

  def update
    @article = Article.find( params[:id] )

    u = User.get_current_user session

    if u and u.id == @article.user_id then
      @article.update_attributes( validate_params )
      flash[:notice] = "Hey #{u.nickname}, Article is '#{@article.title}' Updated!"
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
end
