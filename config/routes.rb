# frozen_string_literal: true

Rails.application.routes.draw do
  resource :account, only: %i[show update], controller: :account
  resources :profiles, only: %i[show index], param: :username do
    # get '/profiles/:username/posts', to: 'posts#index' in resources only index
    resources :posts, only: :index, param: :username
  end

  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[index create]
  end
  delete '/posts/:post_id/likes', to: 'likes#destroy'
end
