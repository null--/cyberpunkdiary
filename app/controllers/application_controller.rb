# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

include ERB::Util
require 'digest/md5'

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
      if not User.is_authorized session then
        flash[:error] = 'Sorry! NASA launched that page to Mars, yesterday! go find it there. \m/'
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

  def redirect_to_index_error
    flash[:error] = 'Sorry! NASA launched that page to Mars, yesterday! go find it there. :D'
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
      format.html { redirect_to :controller => 'users', :action => 'register' }
      format.xml { head :ok }
    end
  end

  def redirect_to_article
    respond_to do |format|
      format.html { redirect_to article_path( @article ) }
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
    feed += '  <lastBuildDate>' + records.first.created_at.to_s + '</lastBuildDate>' + "\n"
    feed += '  <pubDate>' + records.first.created_at.to_s + '</pubDate>' + "\n"
    
    records.each do |rec|
      feed += '    <item>' + "\n"
      feed += '    <title>' + html_escape( title_block.call(rec) ) + '</title>' + "\n"
      feed += '      <description>' + html_escape( desc_block.call(rec) ) + '</description>' + "\n"
      feed += '      <link>' + link_block.call(rec) + '</link>' + "\n"
      feed += '      <guid>' + Digest::MD5.hexdigest(rec.id.to_s) + '</guid>' + "\n"
      feed += '      <pubDate>' + rec.created_at.strftime("%a, %d %b %Y %H:%M:%S +0000") + '</pubDate>' + "\n"
      feed += '    </item>' + "\n"
    end
    
    feed += '</channel>' + "\n"
    feed += '</rss>'
    respond_to do |format|
      # format.html
      format.xml  { render :xml => feed }
    end
  end
end
