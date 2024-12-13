Rails.application.routes.draw do
  devise_for :views
  devise_for :admins
  devise_for :users
  resources :categories
  resources :products do
    resource :buy_now, only: [:show, :create ], controller: :buy_now do
      get "success", on: :collection
    end 
  end 


  resource :cart, only: [:show, :destroy, :create] do

    get "checkout", on: :collection, to: "carts#checkout"
    post "stripe_session", on: :member, to: "carts#stripe_session"
    get "success", on: :member, to: "carts#success"
  end

  
  resource :admin, only: [:show], controller: :admin
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "products#index"
end
