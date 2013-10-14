require 'spec_helper'


describe SetupController do
  
  before (:each) do
   @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def valid_attributes
    {"gym_name"=>"test_gym", 
     "user" => {"name"=>"gymmer_name", "email"=>"gymmer@mail.com", "password"=>"please123", "password_confirmation"=>"please123" }
    }
  end


  describe "POST #create" do
    
   describe "with valid params" do
      specify "creates a new gym and assigns as @gym" do
        post :create, valid_attributes
        assigns(:gym).should be_persisted
      end
   
      specify "creates a new user assigns as @user" do
        post :create, valid_attributes
        assigns(:user).should be_persisted
      end

      specify "redirects to the root path" do
        post :create, valid_attributes
        response.should redirect_to root_path
      end
  end

   describe "with invalid params" do

      it "assigns a newly created but unsaved gym as @gym" do
        Gym.any_instance.stub(:save).and_return(false)
        post :create, valid_attributes
        assigns(:gym).should be_a_new(Gym)
      end

   end

  end



end


