class ApplicationController < ActionController::Base
  protect_from_forgery

  def ensure_admin
    if( !user_signed_in? )
      authenticate_user!
      return false
    elsif( !current_user.is_owner? )
      redirect_to("/")
      return false
    end

    return true
  end
end
