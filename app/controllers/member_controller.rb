class MemberController < ApplicationController
  before_filter :authenticate_user!

  def profile
    @user = User.find(params[:id])
  end

  def myprofile
    @user = current_user
  end

  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    params[:user][:gym_id] = current_user.gym.id
    @user = User.new(params[:user])
    @user.role = "member"

    respond_to do |format|
      if @user.save

        begin

          #if( @user.role == NimbleConstants::CUSTOMER_ROLE )
            #@user.send_reset_password_instructions
            #UserMailer.new_user_email(@user).deliver
          #end

        rescue Exception => exception
          logger.info( "exception sending user email: " + exception.message )
          exception.backtrace.each { |line| logger.error line }
        end

        format.html { redirect_to current_user.gym, notice: 'Member was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        @save_path = admin_users_path
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end
end
