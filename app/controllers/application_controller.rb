# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_access

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def check_access
    if params[:action] == 'create' or
       params[:action] == 'new' or
       params[:action] == 'update' or 
       params[:action] == 'edit' or
       params[:action] == 'delete' or
       params[:action] == 'destroy'
    then
      if not User.is_authorized(session[:session_id]) then
        flash[:error] = 'Sound the Alarm!'
        redirect_to_index
      end
      return
    end  
  end

  def redirect_to_index
    respond_to do |format|
      format.html { redirect_to( articles_url ) }
      format.xml { head :ok }
    end
  end

  def redirect_to_login
    respond_to do |format|
      format.html { redirect_to :controller => 'users', :action => 'login' }
      format.xml { head :ok }
    end
  end

  def redirect_to_article
    respond_to do |format|
      format.html { redirect_to article_path( @article ) }
      format.xml { head :ok }
    end
  end
end
