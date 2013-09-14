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
end
