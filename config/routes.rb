Simplegym::Application.routes.draw do
  get "member/myprofile"
  match "member/profile/:id" => "member#profile", :as => "member_profile"
  get "member/new"
  get "member/update"
  match "member/create" => 'member#create', :via => :post

  get "static/index"
  root :to => "static#index"

  devise_for :users, :controllers => { :registrations => "setup" , :sessions => 'sessions', :passwords => 'passwords'}, :path_names => { :sign_in => 'login', :sign_up => 'register', :sign_out => 'logout' }
  resources :gyms

end
