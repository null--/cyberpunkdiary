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
      :body => params[:article][:body]
    }
  end

  def redirect_to_index
    respond_to do |format|
      format.html { redirect_to( articles_url ) }
      format.xml { head :ok }
    end
  end

  def redirect_to_article
    respond_to do |format|
      format.html { redirect_to article_path( @article ) }
      format.xml { head :ok }
    end
  end

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find( params[:id] )
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
    @article.save

    redirect_to_article
  end

  def update
    @article = Article.find( params[:id] )
    @article.update_attributes( validate_params )
    
    # flash.notice = "Article '#{@article.title}' Updated!"

    redirect_to_article
  end

  def destroy
    @article = Article.find( params[:id] )
    @article.destroy

    redirect_to_index
  end
end
