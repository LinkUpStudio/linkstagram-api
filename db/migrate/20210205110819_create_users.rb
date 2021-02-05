# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :login
      t.text :description, null: true
      t.string :profile_photo
      t.integer :followers
      t.integer :following
      t.references :account, null: true, foreign_key: true

      t.timestamps
    end
  end
end
