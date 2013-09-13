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

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find( params[:id] )
  end

  def new
    @article = Article.new
  end

  def create
    # @article = Article.new

    # @article.title = params[:article][:title]
    # @article.abstract = params[:article][:abstract]
    # @article.body = params[:article][:body]
    
    @article = Article.new( validate_params )
    @article.save

    redirect_to article_path(@article)
  end

end
