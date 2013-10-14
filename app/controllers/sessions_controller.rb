class SessionsController < Devise::SessionsController
  layout 'setup'
  def create
    logger.info "Attempt to sign in by #{ params[:user][:email] }"
    super
  end
  
  def destroy
    super
  end    
end










