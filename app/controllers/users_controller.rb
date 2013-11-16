require 'digest/sha1'

class UsersController < ApplicationController  
  def show
    @user = User.find( params[:id] )
    @total = @user.articles.count

    @perpage = CPDConf.user_perp
    @page = (params[:page] || '1').to_i;

    @articles = Article.find(:all, :conditions => {:user_id => @user.id}, :order => "created_at desc", :limit => @perpage, :offset => (@page - 1) * @perpage);

    @n_page = @total / @perpage;
    @n_page = @n_page + 1 if @n_page * @perpage != @total
  end

  def register
    @user = User.new
  end

  def goblack
	orig_captcha = session[:captcha]
    session.delete(:captcha)
    
    if (not orig_captcha.nil?) and orig_captcha == params[:captcha] then
      vname = User.find(:first, :conditions => {:username => params[:user][:username]}).nil?
      vmail = User.find(:first, :conditions => {:email => params[:user][:email]}).nil?
      vnick = User.find(:first, :conditions => {:nickname => params[:user][:nickname]}).nil?

      if vname and vmail and vnick then
        @user = User.new
      
        @user.username = params[:user][:username]
        @user.password = Digest::SHA256.hexdigest(params[:user][:password])
        @user.email = params[:user][:email]
        @user.nickname = params[:user][:nickname]
        @user.session_id = session[:session_id]
        @user.save

        flash[:notice] = CPDConf.welcome_msg( @user.nickname )
        redirect_to_index
      else
        flash[:error] = CPDConf.username_err if not vname
        flash[:error] = CPDConf.nickname_err if not vnick
        flash[:error] = CPDConf.email_err if not vmail

        redirect_to_register
      end
    else
      flash[:error] = CPDConf.captcha_err
      redirect_to_register
    end
  end

  def login
    @user = User.new;
  end

  def authenticate
    @user = User.find(:first, 
                      :conditions =>
                      { :username => params[:user][:username] }
                      )
    if @user and @user.password == Digest::SHA256.hexdigest(params[:user][:password]) then
      @user.session_id = session[:session_id]
      @user.save

      flash[:notice] = CPDConf.login_msg( @user.nickname )
      redirect_to_index
    else
      flash[:error] = CPDConf.auth_faild_err
      redirect_to_login
    end
  end

  def logout
    @users = User.find(:all ,:conditions => {:session_id => session[:session_id]})

    if @users.length == 0 then
      flash[:error] = CPDConf.invalid_session_err
    else
      @users.each do |u|
        u.session_id = 'unathorized'
        u.save
      end
      flash[:notice] = CPDConf.logout_msg
    end
    redirect_to_index
  end

  def user_rss
    user = User.find( params[:id] )
   if not user.nil? then
     articles = Article.find(:all, :conditions => {:user_id => user.id}, :order => "created_at desc", :limit => 22, :offset => 0);
     
     generate_rss(articles,
                  CPDConf.user_rss_title(user.nickname), 
                  Proc.new {|art| art.title}, 
                  Proc.new {|art| art.abstract}, 
                  Proc.new {|art| 'http://' + request.host + ':' + request.port.to_s + '/articles/' + art.id.to_s})
   end
  end
  
  def edit
  
  end
end
