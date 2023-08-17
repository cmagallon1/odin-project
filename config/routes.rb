# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'posts#index'

  resources :users, only: %i[index update edit]

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :friend_requests, only: %i[create index update]
  resources :posts, only: %i[index show new create] do
    resources :comments, only: %i[new create]
    resources :likes, only: [:create]
  end
  resource :profile
end
