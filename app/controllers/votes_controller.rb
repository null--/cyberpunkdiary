class VotesController < ApplicationController
  def edit
    uid = User.get_current_user session
    
    if not uid then
      redirect_to_index_error
      return
    end

    aid = params[:article_id]

    scr = 0
    scr = 1 if params[:score] == '1337'
    scr = -1 if params[:score] == 'lame'

    @article = Article.find( aid )

    if @article and scr != 0 then
      vote = Vote.find(:first, :conditions => {:article_id => aid, :user_id => uid} )

      # if user voted before
      if vote then
        if vote.score == -1 then
          @article.lame = @article.lame - 1
        else
          @article.leet = @article.leet - 1
        end

        vote.score = scr
        vote.save

        flash[:notice] = "Vote has been updated!"
      else
      # if it's a new vote
        vote = Vote.new({:article_id => aid, :user_id => uid, :score => scr})
        vote.save

        flash[:notice] = "Vote has been stored!"
      end
              
      # update article
      if scr == -1 then
        @article.lame = @article.lame + 1
      else
        @article.leet = @article.leet + 1
      end
      @article.save

      redirect_to_article
    else
      flash[:error] = "Story not found!"
      redirect_to_index
    end
  end
end
