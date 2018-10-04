Rails.application.routes.draw do
  # get 'sessions/new'
  # get 'sessions/create'
  # get 'sessions/destroy'


   resources :status

  resources :devices
  
   resources :user_homes
   resources :homes

  # resources :homes do
  # 	resources :rooms
  # end

  #resources :users
  # return homes of user
  match 'users/homes', to: 'users#get_user_homes', via: [:get]
  #get all user
  match 'users', to: 'users#index', via: [:get]
  match 'users/devices', to: 'users#get_all_device_info', via: [:get]
  #get get_identifier_status
  match 'status/identifier/:identifier_id', to: 'devices#get_identifier_status', via: [:get]
  # get all member of home
  match 'homes/:id/users', to: 'homes#get_users_of_home', via: [:get]
  #tet
  match 'users/test', to: 'users#test', via: [:get]

  #create device
  match '/device', to: 'devices#create',via: [:post]
  #create home for user
  match 'users/homes', to: 'users#create_home',via: [:post]
  #create room for home
  match 'users/homes/:home_id/rooms',to: 'users#create_room_home',via: [:post]
  #add_new_member_home
  match 'users/user_homes/homes/:home_id', to: 'users#add_new_member_home', via: [:post]
  #update beacon status
  match 'users/devices/status', to: 'users#update_beacon_status', via: [:post]
  #POST /status
  match '/status', to: 'status#create', via: [:post]

  # Post register
  match "/register", to: "users#register", via: [:post]
  #login
  match '/login', to:'users#login', via: [:post]
  #logout
  match '/logout', to:'users#logout', via: [:delete]

  # update home role for user
  match 'users/user_homes/homes/:home_id', to: 'users#update_role_user_home', via: [:put]
  # put 
  match "users/homes/:home_id/devices" ,to: "users#buy_device", via: [:put]

  #delete home of user via :home_id
  match '/users/homes/:home_id', to:'users#delete_home', via: [:delete]

  #delete home member
  match 'users/user_homes/homes/:home_id', to: 'users#delete_home_member', via: [:delete]
  # get "/test"  => "users#test"
  # #get home of user
  # # get  "/users/:id" => "homes#get_home_user" 
  # # get  "/users/homes" => "homes#get_home_user"                          
  # # create home of user
  # post "users/homes" => "users#create_home"

  # #register
  # post "/register" => "users#register"
  # #login
  # post "/login" => "users#login"

  # #buy device
    
  # # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
