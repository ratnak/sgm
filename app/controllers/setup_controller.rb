class SetupController < Devise::RegistrationsController
  layout 'setup'
  # creates a new gym and gym owner

  def new
   super
  end

  def create
    params[:user][:role] = "owner";
    super

    if( !@user.id.nil? )
      @gym = Gym.new
      @gym.name = params[:gym_name]
      @gym.save
      @user.gym_id = @gym.id
      #@user.name = params[:name]
      @user.save!
      #UserMailer.welcome_email(@user).deliver
      logger.debug( "new user and gym created" );
    end
  end
end
