require 'sidekiq/web'

Walla::Application.routes.draw do

  get "test_oauth/show"
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks' }

  # User FrontEnd
  get  '/go/:id',       to: 'framer#index', as: :go
  post '/go/:id/next',  to: 'framer#next'
  post '/go/:id/learn', to: 'framer#learn'
  get  '/admin/stats',  to: 'framer#stats'
  get  '/admin/profiles',  to: 'framer#profiles'

  # API
  resources :tweets
  resources :axa, only: [:create, :index]

  # Sidekiq monitoring interface
  mount Sidekiq::Web => '/sidekiq'

  # Bullshit
  root 'doc#index'
  get  '/documentation', to: 'doc#documentation', as: :documentation


  # get '/sf_oauth', to: 'users/omniauth_callbacks#sales_force'

end
