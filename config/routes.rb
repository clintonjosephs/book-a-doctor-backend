Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :v1, defaults: { format: 'json' } do
    post 'users/login' => 'users#login'
    post 'users/signup' => 'users#signup'
    resources :doctors, only: [:new, :destroy, :show, :index]
    resources :appointments, only: [:new, :destroy, :index]
  end
end
