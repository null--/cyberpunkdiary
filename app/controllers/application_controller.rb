# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

include ERB::Util
require 'digest/md5'

# CONFIGURATION
class CPDConf
  def initialize
  end
    
  # articles per page
  def self.article_perp
    16
  end
  
  def self.tag_perp
    12
  end
  
  def self.user_perp
    8
  end
  
  def self.min_font_size
    10
  end
  
  def self.max_font_size
    48
  end
  
  def self.auth_faild_err
    "James Jr.:\"Why's he running, Dad?\"- Lt. Gordon: \"Because we have to chase him.\""
  end
  
  def self.unauth_err
    "He turns to me and says, \"Why so serious?\" Comes at me with the knife. \"WHY SO SERIOUS?\" He sticks the blade in my mouth... \"Let's put a smile on that face.\" And..."
  end
  
  def self.access_denied_err
    'Sorry! NASA launched that page to Mars, yesterday! go find it there. :D'
  end
  
  def self.general_exception_err
    "Hey yo man, that's not cool!"
  end
  
  def self.article_update(user, article)
    "Hey #{user}, '#{article}' has been updated."
  end
  
  def self.diary_rss_title
    'Cyberpunkdiary: 1337 or lame'
  end
  
  def self.comment_rss_title(article)
    'Latest comments of ' + article
  end
  
  def self.tag_rss_title(tag)
    'Latest articles tagged as ' + tag
  end
  
  def self.user_rss_title(user)
    'Latest stories of ' + user
  end
  
  def self.welcome_msg(user)
    "Once you go black, there is no turning back. #{user}, welcome!"
  end
  
  def self.username_err
    "This username already exists!"
  end
  
  def self.nickname_err
    "Your nickname belongs to somebody!"
  end
  
  def self.email_err
    "This email was used before."
  end
  
  def self.captcha_err
    "Captcha code was wrong!"
  end
  
  def self.invalid_session_err
    "Invalid Session"
  end
  
  def self.login_msg( user )
    "#{user}, welcome back!"
  end
  
  def self.logout_msg
    "Don't go too far away, Alice!"
  end
  
  def self.comment_delete_msg
    "Your comment has been deleted."
  end
  
  def self.user_edit_msg( user )
    "Your profile has been updated."
  end
  
  def self.user_not_found_err
    "User not found!"
  end
  
  def self.wrong_answer_err
    "WRONG ANSWER!"
  end
  
  def self.no_recov_qst_err
    "There is no recovery question! you are doomed!"
  end

  def self.length_err
    "You're talking too much, tommy!"
  end
end

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_access
  before_filter :check_input

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def check_access
    if (params[:action] == 'create' and params[:controller] != 'users') or
       (params[:action] == 'new' and params[:controller] != 'users') or
       params[:action] == 'update' or 
       params[:action] == 'edit' or
       params[:action] == 'delete' or
       params[:action] == 'destroy'
    then
      if not User.is_authorized session then
        flash[:error] = CPDConf.unauth_err
        # fail
        redirect_to_index
      end
      return
    end  
    
  rescue => details
    general_rescue details
  end

  def check_input
    msg = ''

    msg = msg + ' - order.length > 4'               if ((not params[:order].nil?) and params[:order].length > 4)
    msg = msg + ' - page.length > 4'                if ((not params[:page].nil?) and params[:page].length > 4)
    msg = msg + ' - dir.length > 4'                 if ((not params[:dir].nil?) and params[:dir].length > 4)
    msg = msg + ' - id.length > 16'                 if ((not params[:id].nil?) and params[:id].length > 16)
    msg = msg + ' - captcha.length > 4'             if ((not params[:captcha].nil?) and params[:captcha].length > 16)

    msg = msg + ' - article_id.length > 4'          if ((not params[:article_id].nil?) and params[:article_id].length > 16)
    msg = msg + ' - icon.length > 4'                if ((not params[:article].nil?) and (not params[:article][:icon].nil?) and params[:article][:icon].length > 4)
    msg = msg + ' - title.length > 64'              if ((not params[:article].nil?) and (not params[:article][:title].nil?) and params[:article][:title].length > 64)
    msg = msg + ' - abstract.length > 256'          if ((not params[:article].nil?) and (not params[:article][:abstract].nil?) and params[:article][:abstract].length > 256)
    msg = msg + ' - tag_list.length > 256'          if ((not params[:article].nil?) and (not params[:article][:tag_list].nil?) and params[:article][:tag_list].length > 256)

    msg = msg + ' - comment.body.length > 512'      if ((not params[:comment].nil?) and (not params[:comment][:body].nil?) and params[:comment][:body].length > 512)

    msg = msg + ' - username.length > 16'           if ((not params[:user].nil?) and (not params[:user][:username].nil?) and params[:user][:username].length > 16)
    msg = msg + ' - username.length > 16'           if ((not params[:username].nil?) and params[:username].length > 16)
    msg = msg + ' - password.length > 64'           if ((not params[:user].nil?) and (not params[:user][:password].nil?) and params[:user][:password].length > 64)
    msg = msg + ' - email.length > 64'              if ((not params[:user].nil?) and (not params[:user][:email].nil?) and params[:user][:email].length > 64)
    msg = msg + ' - nickname.length > 16'           if ((not params[:user].nil?) and (not params[:user][:nickname].nil?) and params[:user][:nickname].length > 16)
    msg = msg + ' - recovery_question.length > 64'  if ((not params[:user].nil?) and (not params[:user][:recov_qst].nil?) and params[:user][:recov_qst].length > 64)
    msg = msg + ' - recovery_answer.length > 64'    if ((not params[:user].nil?) and (not params[:user][:recov_ans].nil?) and params[:user][:recov_ans].length > 64)
    msg = msg + ' - answer.length > 64'             if ((not params[:answer].nil?) and params[:answer].length > 64)
      
    if msg.length > 0 then
      flash[:error] = CPDConf.length_err + msg
      # fail
      # TODO REDIRECT TO SAME PAGE
      redirect_to_index
    end
    return
  rescue => details
    general_rescue details
  end
  
  def redirect_to_index
    respond_to do |format|
      format.html { redirect_to( articles_url ) }
      format.xml { head :ok }
    end
  end

  def redirect_to_index_error
    flash[:error] = CPDConf.access_denied_err
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
  
  def redirect_to_register
    respond_to do |format|
      format.html { redirect_to :controller => 'users', :action => 'new' }
      format.xml { head :ok }
    end
  end

  def redirect_to_recovery
    respond_to do |format|
      format.html { redirect_to :controller => 'users', :action => 'recovery' }
      format.xml { head :ok }
    end
  end
  
  def redirect_to_article
    respond_to do |format|
      format.html { redirect_to article_path( @article ) }
      format.xml { head :ok }
    end
  end
  
  def redirect_to_edit_user
    respond_to do |format|
      format.html { redirect_to edit_user_path( @user ) }
      format.xml { head :ok }
    end
  end
  
  def redirect_to_user
    respond_to do |format|
      format.html { redirect_to user_path( @user ) }
      format.xml { head :ok }
    end
  end
  
  def generate_rss (records, rss_title, title_block, desc_block, link_block)
    feed  = '<?xml version="1.0" encoding="UTF-8" ?>' + "\n"
    feed += '<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/">' + "\n"
    feed += '<channel>' + "\n"
    
    feed += '  <title>[CPD] Cyber Punk Diary</title>' + "\n"
    feed += '  <description>' + html_escape( rss_title ) + '</description>' + "\n"
    feed += '  <link>' + 'http://' + request.host + ':' + request.port.to_s + '</link>' + "\n"
    if not records.nil? and not records.empty? then
      feed += '  <lastBuildDate>' + records.first.created_at.to_s + '</lastBuildDate>' + "\n" 
      feed += '  <pubDate>' + records.first.created_at.to_s + '</pubDate>' + "\n"
      
      if not records.nil? then records.each do |rec|
        feed += '    <item>' + "\n"
        feed += '    <title>' + html_escape( title_block.call(rec) ) + '</title>' + "\n"
        feed += '      <description>' + html_escape( desc_block.call(rec) ) + '</description>' + "\n"
        feed += '      <link>' + link_block.call(rec) + '</link>' + "\n"
        feed += '      <guid>' + Digest::MD5.hexdigest(rec.id.to_s) + '</guid>' + "\n"
        feed += '      <pubDate>' + rec.created_at.strftime("%a, %d %b %Y %H:%M:%S +0000") + '</pubDate>' + "\n"
        feed += '    </item>' + "\n"
      end end
    end
    feed += '</channel>' + "\n"
    feed += '</rss>'
    respond_to do |format|
      # format.html
      format.xml  { render :xml => feed }
    end
  rescue => details
    general_rescue details
  end
  
  def general_rescue details
    flash[:error] = CPDConf.general_exception_err + ' -WTF: ' + details.to_s
    redirect_to_index
  end
end
