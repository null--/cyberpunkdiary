class AdminController < ApplicationController
  before_filter :check_privs

  def check_privs
    u = User.get_current_user session
    if u and u.priv == 10 then
      return true
    end
    
    flash[:error] = CPDConf.unauth_err
    redirect_to_index
    
    nil
    
  rescue => details
    general_rescue details
    
    nil
    
  end

  def index
    @n_comment = Comment.count
    @n_article = Article.count
    @n_user = User.count
    @n_tag = Tag.count
  
  rescue => details
    general_rescue details
  end

  def userlist
    @perpage = 50
    @n_user = User.count
    @page = (params[:page] || '1').to_i

    @users = User.find(:all, :order => "nickname desc", :limit => @perpage, :offset => (@page - 1) * @perpage);
    @n_page = @n_user / @perpage;
    @n_page = @n_page + 1 if @n_page * @perpage != @total
    
  rescue => details
    general_rescue details
    
  end
end
