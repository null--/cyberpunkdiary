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
    
    @total_hits = 0
    @total_leet = 0
    @total_lame = 0
    
    @articles.each do |article|
      @total_hits = @total_hits + article.hits
      @total_leet = @total_leet + article.leet
      @total_lame = @total_lame + article.lame
    end
    
  rescue => details
    general_rescue details
  end

  def new
    @user = User.new
    
  rescue => details
    general_rescue details
  end

  def create
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
        @user.recov_qst = params[:user][:recov_qst]
        @user.recov_ans = Digest::SHA256.hexdigest(params[:user][:recov_ans])
        @user.session_id = session[:session_id]
        @user.priv = 0
        @user.save

        flash[:notice] = CPDConf.welcome_msg( @user.nickname )
        redirect_to_index
      else
        flash[:error] = (flash[:error] + CPDConf.username_err + "<br>") if not vname
        flash[:error] = (flash[:error] + CPDConf.nickname_err + "<br>") if not vnick
        flash[:error] = (flash[:error] + CPDConf.email_err if + "<br>") if not vmail

        redirect_to_register
      end
    else
      flash[:error] = CPDConf.captcha_err
      redirect_to_register
    end
    
  rescue => details
    general_rescue details
  end

  def login
    @user = User.new;
    
  rescue => details
    general_rescue details
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
    
  rescue => details
    general_rescue details
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
    
  rescue => details
    general_rescue details
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
  
  rescue => details
    general_rescue details
  end
  
  def recovery
    # stage 2: get username
    if not params[:username].nil? and params[:answer].nil? then
      orig_captcha = session[:captcha]
      session.delete(:captcha)
      
      if (not orig_captcha.nil?) and orig_captcha == params[:captcha] then
        @user = User.find(:first, :conditions => {:username => params[:username]})
        
        if @user.nil? then
          flash[:error] = CPDConf.user_not_found_err
          redirect_to_recovery
        elsif @user.recov_qst.nil? or @user.recov_qst.length == 0 or 
              @user.recov_ans.nil? or @user.recov_ans.length == 0 then
          flash[:error] = CPDConf.no_recov_qst_err
          redirect_to_index
        end
      else
        flash[:error] = CPDConf.captcha_err + orig_captcha + params[:captcha]
        redirect_to_recovery
      end
    # stage 3: match answers
    elsif not params[:username].nil? and not params[:answer].nil? then
      orig_captcha = session[:captcha]
      session.delete(:captcha)
      
      if (not orig_captcha.nil?) and orig_captcha == params[:captcha] then
        @user = User.find(:first, :conditions => {:username => params[:username]})
        
        if Digest::SHA256.hexdigest(params[:answer]) == @user.recov_ans then
          @user.session_id = session[:session_id]
          @user.save

          flash[:notice] = CPDConf.login_msg( @user.nickname )
          redirect_to_edit_user
        else
          flash[:error] = CPDConf.wrong_answer_err
          redirect_to_recovery
        end
        if @user.nil? then
          flash[:error] = CPDConf.user_not_found_err
          redirect_to_recovery
        end
      else
        flash[:error] = CPDConf.captcha_err
        redirect_to_recovery
      end
    end
    
  rescue => details
    general_rescue details
  end
  
  def edit
    @user = User.find( params[:id] )
    
  rescue => details
    general_rescue details
  end
  
  def update
    @user = User.find( params[:id] )
    orig_captcha = session[:captcha]
    session.delete(:captcha)
    
    u = User.get_current_user session

    if (not orig_captcha.nil?) and orig_captcha == params[:captcha] then
      if u and (u.id == @user.id || u.priv == 10) then
        vname = User.find(:first, :conditions => {:username => params[:user][:username]}).nil?
        vmail = User.find(:first, :conditions => {:email => params[:user][:email]}).nil?
        vnick = User.find(:first, :conditions => {:nickname => params[:user][:nickname]}).nil?

        if (vname or @user.username == params[:user][:username]) and 
           (vmail or @user.email == params[:user][:email]) and 
           (vnick or @user.username == params[:user][:nickname]) 
        then
          @user.username = params[:user][:username]
          if @user.password != params[:user][:password] then
            @user.password = Digest::SHA256.hexdigest(params[:user][:password])
          end
          @user.email = params[:user][:email]
          @user.nickname = params[:user][:nickname]
          
          @user.recov_qst = params[:user][:recov_qst]
          if @user.recov_ans != params[:user][:recov_ans] then
            @user.recov_ans = Digest::SHA256.hexdigest(params[:user][:recov_ans])
          end
          @user.priv = @user.priv
          @user.save

          flash[:notice] = CPDConf.user_edit_msg( @user.nickname )
          redirect_to_user
        else
          flash[:error] = (flash[:error] + CPDConf.username_err + "<br>") if not vname
          flash[:error] = (flash[:error] + CPDConf.nickname_err + "<br>") if not vnick
          flash[:error] = (flash[:error] + CPDConf.email_err if + "<br>") if not vmail

					redirect_to_edit_user
				end
			else
				flash[:error] = CPDConf.unauth_error
				redirect_to_index
			end
		else
      flash[:error] = CPDConf.captcha_err
      redirect_to_edit_user
    end
    
  rescue => details
    general_rescue details
  end
end
