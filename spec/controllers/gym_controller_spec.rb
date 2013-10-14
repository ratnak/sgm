require 'spec_helper'

describe GymsController do
  login_user

  def valid_attributes
    FactoryGirl.build(:gym)
  end

  describe 'GET index' do
    it 'assigns all gyms as @gyms' do
      gym = FactoryGirl.create(:gym)
      get :index, {}
      assigns(:gyms).should eq([gym])
    end
  end

  describe 'GET show' do
    it 'assigns the requested gym as @gym' do
      gym = FactoryGirl.create(:gym)
      get :show, {:id => gym.to_param}
      assigns(:gym).should eq(gym)
    end
  end


  describe 'GET new' do
    it 'assigns a new gym as @gym' do
      get :new, {}
      assigns(:gym).should be_a_new(Gym)
    end
  end

   describe 'GET edit' do
    it 'assigns the requested gym as @gym' do
      gym = FactoryGirl.create(:gym)
      get :edit, {:id => gym.to_param}
      assigns(:gym).should eq(gym)
    end
   end


   describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Gym'do
        expect {
          post :create, {:gym => valid_attributes}
        }.to change(Gym, :count).by(1)
      end

      it 'assigns a newly created gym as @gym' do
        post :create, {:gym => valid_attributes}
        assigns(:gym).should be_a(Gym)
        assigns(:gym).should be_persisted
      end

      it 'redirects to the created gym' do
        post :create, {:gym => valid_attributes}
        response.should redirect_to(Gym.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved gym as @gym' do
        Gym.any_instance.stub(:save).and_return(false)
        post :create, {:gym=> {name: 'new gym'}}
        assigns(:gym).should be_a_new(Gym)
      end

      it 're-renders the :new template' do
        Gym.any_instance.stub(:save).and_return(false)
        post :create, {:gym => { :name => '' }}
        response.should render_template(:new)
      end
    end
  end

   describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested gym' do
        gym = FactoryGirl.create(:gym)
        Gym.any_instance.should_receive(:update_attributes).with({ 'name' => 'MyString' })
        put :update, {:id => gym.to_param, :gym => { 'name' => 'MyString' }}
      end

      it 'assigns the requested gym as @gym' do
        gym = FactoryGirl.create(:gym)
        put :update, {:id => gym.to_param, :gym => {name:'new gym'}}
        assigns(:gym).should eq(gym)
        assigns(:gym).name.should == 'new gym'
      end

      it 'redirects to the @gym' do
        gym = FactoryGirl.create(:gym)
        put :update, {:id => gym.to_param, :gym => valid_attributes}
        response.should redirect_to(gym)
      end
    end

    describe 'with invalid params' do
      it 'assigns the gym as @gym' do
        gym = FactoryGirl.create(:gym)
        Gym.any_instance.stub(:save).and_return(false)
        put :update, {:id => gym.to_param, :gym => { :name => '' }}
        assigns(:gym).should  eq(gym)

      end

      it 're-renders the "edit" template' do
        gym = FactoryGirl.create(:gym)
        Gym.any_instance.stub(:save).and_return(false)
        put :update, {:id => gym.to_param, :property => { :name => '' }}
        response.should render_template(:edit)
      end
    end
   end
  
   describe 'DELETE destroy' do
    it 'destroys the requested gym' do
      gym = FactoryGirl.create(:gym)
      expect {
        delete :destroy, {:id => gym.to_param}
      }.to change(Gym, :count).by(-1)
    end

    it 'redirects to the gyms list' do
      gym = FactoryGirl.create(:gym)
      delete :destroy, {:id => gym.to_param}
      response.should redirect_to(gyms_url)
    end
  end
end


