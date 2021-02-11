# frozen_string_literal: true

Rails.application.routes.draw do
  resources :account, only: %i[show update]
  patch '/account', to: 'account#update'
  get '/account', to: 'account#show'
  resources :profiles
  resources :posts
end
