require 'resque/server'
require 'resque/scheduler/server'

require "resque_web"
Rails.application.routes.draw do
  mount ResqueWeb::Engine => "/jobs"
  mount ActionCable.server => '/cable'

  root to: 'application#app_start'

  get 'account/:perishable_token/activate', to: 'account#activate'
  get 'account/:perishable_token/verify', to: 'account#verify'

  resources :webhooks, only: [] do
    collection do
      post :sms
    end
  end

  namespace :api do
    get 'me', to: 'sessions#show'
    get 'valid_session', to: 'sessions#valid_session'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    get 'auth_token', to: 'sessions#auth_token'

    resource :dashboard, controller: :dashboard, only: [:show], defaults: { format: :json }
    resource :profile, controller: :profile, only: %i[show update], defaults: { format: :json }
    resource :forgot_password, controller: :forgot_password, only: %i[create update], defaults: { format: :json }

    resources :autoresponders, only: %i[index update], defaults: { format: :json }
    resources :chat_access_keys, only: %i[index create destroy], defaults: { format: :json }
    resources :phone_numbers, only: %i[index show create update destroy], defaults: { format: :json }
    resources :resource_lists, only: [], defaults: { format: :json } do
      collection do
        post :number_search, defaults: { format: :json }
      end
    end
    resources :users, only: %i[index show create update destroy], defaults: { format: :json } do
      member do
        post :reset_password, defaults: { format: :json }
      end
    end
  end

  get '*path', to: "application#goto_app_start", constraints: lambda { |req| req.format != :csv }
end
