# frozen_string_literal: true

class CreateRodauth < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'citext'

    create_table :accounts do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :username, null: false, index: { unique: true }
      t.text :description
      t.jsonb :profile_photo_data
      t.integer :followers
      t.integer :following
    end

    # Used if storing password hashes in a separate table (default)
    create_table :account_password_hashes do |t|
      t.foreign_key :accounts, column: :id
      t.string :password_hash, null: false
    end

    # Used by the password reset feature
    create_table :account_password_reset_keys do |t|
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.datetime :deadline, null: false
      t.datetime :email_last_sent, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # Used by the verify login change feature
    create_table :account_login_change_keys do |t|
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.string :login, null: false
      t.datetime :deadline, null: false
    end
  end
end
