# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_205_110_819) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'citext'
  enable_extension 'plpgsql'

  create_table 'account_login_change_keys', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'login', null: false
    t.datetime 'deadline', null: false
  end

  create_table 'account_password_hashes', force: :cascade do |t|
    t.string 'password_hash', null: false
  end

  create_table 'account_password_reset_keys', force: :cascade do |t|
    t.string 'key', null: false
    t.datetime 'deadline', null: false
    t.datetime 'email_last_sent', default: -> { 'CURRENT_TIMESTAMP' }, null: false
  end

  create_table 'accounts', force: :cascade do |t|
    t.string 'email', null: false
    t.index ['email'], name: 'index_accounts_on_email', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'login'
    t.text 'description'
    t.string 'profile_photo'
    t.integer 'followers'
    t.integer 'following'
    t.bigint 'account_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['account_id'], name: 'index_users_on_account_id'
  end

  add_foreign_key 'account_login_change_keys', 'accounts', column: 'id'
  add_foreign_key 'account_password_hashes', 'accounts', column: 'id'
  add_foreign_key 'account_password_reset_keys', 'accounts', column: 'id'
  add_foreign_key 'users', 'accounts'
end