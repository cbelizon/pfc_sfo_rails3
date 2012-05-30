PfcSfoUpdate::Application.routes.draw do
  resources :rounds do
    collection do
      get :previous
      get :next
    end
  end
  resources :leagues, :only => :index do
    collection do
      post :new_leagues
      post :promotion
      put :close_teams
      put :open_teams
      post :simulate_rounds
      put :start_rounds
      put :next_rounds
      post :create_calendar
      get :messages
      post :message_destroy
      get :message_edit
      put :message_modify
      get :message_new
      post :message_create
    end
  end
  resources :seasons, :only => [:show], :path_prefix => '/:locale'
  resources :match_generals, :only => [:show]
  resources :users do
    get :no_club, :on => :collection
    get :all, :on     => :collection
  end
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  resource :user_session
  resources :clubs do
    get :team, :on            => :member
    put :replace, :on         => :member
    get :finances, :on        => :member
    put :ticket_price, :on    => :member
    get :received_offers, :on => :member
    post :make_offer, :on     => :member
    put :accept_offer, :on    => :member
    put :reject_offer, :on    => :member
    get :trainings, :on       => :member
    post :train_ability, :on  => :member
    get :sent_offers, :on     => :member
    put :cancel_offer, :on    => :member
    put :tactic, :on          => :member
  end
  resources :players, :only => [:show]
  match 'home', :controller => 'home', :action => 'index'
  root :controller => 'home', :action => 'index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
