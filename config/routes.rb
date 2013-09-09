SampleApp::Application.routes.draw do
  
  resources :players
  get "blackjacks/main"
  get "blackjacks/topten"
  resources :blackjacks

  match "api/gameusers/topten", to: 'gameusers#topten', via: 'get'
  match "api/gameusers/getuser", to: 'gameusers#getuser', via: 'get'

  scope "api" do
    resources :blackjacks
    resources :gameusers
  end

  get "kidcomments/new"
  get "kidcomments/index"
  get "kidcomments/destroy"
  get "kids/new"
  get "kids/update"
  get "kids/show"
  get "kids/index"
  get 'tags/:tag', to: 'kids#index', as: :tag
  resources :kids
  resources :users
  resources :users do
	member do
		get :following, :followers
	end
  end
  resources :kidcomments, only: [:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  match '/kid_comments',    to: 'kidcomments#create',    via: 'post'

  match '/report',  to: 'kids#new',            via: 'get'

  root to: 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

# The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
