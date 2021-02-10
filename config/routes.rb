# frozen_string_literal: true

Rails.application.routes.draw do
  resources :account, only: %i[show, update]
  patch '/account', to: 'account#update'
  resources :profiles
end
