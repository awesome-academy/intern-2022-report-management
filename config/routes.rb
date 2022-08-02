Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    root "accounts#index"
    get "/index", to: "home#index"
    put "/manager/reports", to: "manager/reports#update"

    devise_for :users, controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords",
      confirmations: "users/confirmations"
    }, skip: :omniauth_callbacks

    namespace :manager do
      resources :reports, only: %i(index show update)
      resources :users
    end

    resources :accounts, only: %i(index edit update)
    resources :reports
    resources :comments, only: :create
  end
end
