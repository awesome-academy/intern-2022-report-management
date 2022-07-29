Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "accounts#index"
    get "/index", to: "home#index"
    put "/manager/reports", to: "manager/reports#update"

    devise_for :users, controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords",
      confirmations: "users/confirmations"
    }

    namespace :manager do
      resources :reports, only: %i(index show update)
      resources :users
    end

    resources :accounts, only: %i(index edit update)
    resources :reports
    resources :comments, only: :create
  end
end
