# frozen_string_literal: true

Rails.application.routes.draw do
  resource :account, only: %i[show update], controller: :account
  # patch '/account', to: 'account#update'
  # get '/account', to: 'account#show'
  resources :profiles
  resources :posts do
    resources :likes, only: %i[create destroy]
  end
  delete '/posts/:post_id/likes', to: 'likes#destroy'
end
