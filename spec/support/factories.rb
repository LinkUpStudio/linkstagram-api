# frozen_string_literal: true

require 'bcrypt'

FactoryBot.define do
  factory :user do
    sequence :login do |n|
      "user#{n}"
    end
    description { 'Description text' }
    profile_photo { 'Profile photo' }
    account
  end

  factory :account do
    sequence :email do |n|
      "person#{n}@example.com"
    end

    transient do
      password { 'password' }
    end

    after(:create) do |account, evaluator|
      password = BCrypt::Password.create(
        evaluator.password, cost: BCrypt::Engine::MIN_COST
      )

      DB[:account_password_hashes].insert(
        id: account.id, password_hash: password.to_s
      )
    end
  end
end
