class CommentsController < ApplicationController

  def validate_comment
    # params.require(:comment).permit(:author_name, :body)

    if not params[:comment] or  
        not params[:comment][:body] 
    then
      # => TODO: fail is not cool!
      fail
    end

    # => TODO: SQLi, XSS Validation    
    { 
      :body => params[:comment][:body]
    }
  end

  def create
    u = User.get_current_user session
    if u then
      @comment = Comment.new( validate_comment )
    
      @comment.article_id = params[:article_id]
      @comment.user_id = u.id

      @comment.save
      redirect_to article_path(@comment.article)
    else
      redirect_to_index_error
    end
  end

  def destroy
    @comment = Comment.find( params[:id] )
    @article = @comment.article if @comment

    u = User.get_current_user session

    if @comment and @article and u and (u.id == @comment.user_id or u.priv == 10) then
      @comment.destroy

      flash[:notice] = "Your comment has been deleted."
      redirect_to_article
    elsif @article then
      flash[:error] = "You cannot do that!"
      redirect_to_article
    else
      redirect_to_index_error
    end
  end
end
