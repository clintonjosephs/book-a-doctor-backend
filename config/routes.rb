Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    post 'users/login' => 'users#login'
    post 'users/signup' => 'users#signup'
    resources :doctors, only: [:create, :destroy, :show, :index]
    resources :appointments, only: [:new, :show, :destroy, :index]
  end
end
