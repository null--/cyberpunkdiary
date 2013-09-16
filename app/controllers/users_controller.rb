require 'digest/sha1'

class UsersController < ApplicationController  
  def show
    @user = User.find( params[:id] )
  end

  def register
    @user = User.new
  end

  def goblack
	orig_captcha = session[:captcha]
    session.delete(:captcha)
    
    if orig_captcha == params[:captcha] then
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

        flash[:notice] = "Once you go black, there is no turning back. #{@user.nickname}, welcome!"
        redirect_to_index
      else
        flash[:error] = "Username was taken" if not vname
        flash[:error] = "Nickname was taken" if not vnick
        flash[:error] = "Email was taken" if not vmail

        redirect_to_register
      end
    else
      flash[:error] = "Captcha code was wrong!"
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

      flash[:notice] = "#{@user.nickname}, welcome back!"
      redirect_to_index
    else
      flash[:error] = "Sorry! Who are you? again"
      redirect_to_login
    end
  end

  def logout
    @users = User.find(:all ,:conditions => {:session_id => session[:session_id]})

    if @users.length == 0 then
      flash[:error] = "Invalid Session"
    else
      @users.each do |u|
        u.session_id = 'unathorzed'
        u.save
      end
      flash[:notice] = "Seasion Closed!"
    end
    redirect_to_index
  end

  def edit
  end
end
