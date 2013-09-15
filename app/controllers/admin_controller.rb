class AdminController < ApplicationController
  before_filter :check_privs

  def check_privs
    u = User.get_current_user session
    if u.priv == 10 then
      return true
    end
    
    flash[:error] = 'YOU ARE NOT AUTHORIZED'
    redirect_to_index
    nil
  end

  def index
  end

  def userlist
  end

  def articlelist
  end
end
