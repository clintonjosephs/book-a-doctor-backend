Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1, defaults: { format: 'json' } do
    post 'users/login' => 'users#login'
    post 'users/signup' => 'users#signup'
    resources :doctors, only: [:new, :destroy, :show, :index]
    resources :appointments, only: [:new, :destroy, :index]
  end
end
