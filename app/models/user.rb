class User < ActiveRecord::Base
  has_many :articles
  has_many :comments
  has_many :vote

  def self.is_authorized session
    if not session[ :session_id ] then
      return false
    end

    begin
      User.find(:all, :conditions => {:session_id => session[ :session_id ]}).length == 1
    rescue
      return false
    end
  end

  def self.get_current_user session
    if not session[ :session_id ] then
      return nil
    end
    
    begin
      User.find(:all, :conditions => {:session_id => session[ :session_id ]}).first
    rescue
      nil
    end
  end
  
  def avatar_url(size = 75)
    if self.email.nil? then
      "/images/images/user.jpg"
    else
	  gravatar_id = Digest::MD5.hexdigest(self.email.downcase.strip)
	  "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
	end
  end
  
end
