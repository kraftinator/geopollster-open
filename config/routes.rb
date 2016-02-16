Geopollster::Application.routes.draw do
  
  

  get "oauth/start"
  get "oauth/callback" 
  get "oauth/twitter"
  get "oauth/twitter_callback" 
  get "standings/democrats"
  get "standings/football"
  get "standings/republicans"
  get "users/cancel_signup"
  get "users/confirm_delete"
  get "users/delete"
  get "users/friends"
  get "users/friends_checkins"
  get "users/home"
  get "users/login"
	get "users/logout"
	get "users/post_comment"
	get "users/foursquare_invite"
	get "users/refresh_checkin_history"
	get "users/refresh_friends_checkins"
	get "users/settings"
	get "users/signup"
	get "users/twitter_disconnect"
  
  post "checkins/push"
  post "users/activate"
  post "users/create_comment"
  post "users/create_invite"
  post "users/update"
  
  match 'categories/:url_slug', :to => 'categories#show'
  match 'cities/:id', :to => 'cities#show'
  match 'top-level-categories', :to => 'categories#index'
  match 'top-level-categories/:url_slug', :to => 'categories#top_level'
  match 'mobile-devices', :to => 'mobile_devices#index'
  match 'companies', :to => 'companies#index'
  match 'companies/:url_slug', :to => 'companies#show'
  match 'polling', :to => 'polling#show'
  match 'parties', :to => 'parties#index'
  match 'parties/:url_slug', :to => 'parties#show'
  match 'standings', :to => 'standings#index'
  match 'states', :to => 'states#index'
  match 'states/:url_slug', :to => 'states#show'
  match 'users/friend/:foursquare_id', :to => 'users#friend'
  match 'venues/:foursquare_guid', :to => 'venues#show'
  match 'about', :to => 'welcome#about'
  match 'contact', :to => 'welcome#contact'
  match 'faq', :to => 'welcome#faq'
  match 'press', :to => 'welcome#press'
  match 'press-release', :to => 'welcome#press_release'
  match 'privacy', :to => 'welcome#privacy'
  match 'team', :to => 'welcome#team'
  match 'terms', :to => 'welcome#terms'  
  match 'zip-codes/:name', :to => 'zip_codes#show'

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
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
