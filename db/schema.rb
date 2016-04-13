# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_160_106_014_618) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'email_verifications', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'code'
    t.boolean 'verified', default: false
    t.string 'last_verified_at'
  end

  create_table 'relays', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'name'
    t.string 'uuid'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'sensors', force: :cascade do |t|
    t.string 'name'
    t.string 'account_id'
    t.string 'uuid'
    t.float 'latitude'
    t.float 'longitude'
    t.integer 'sample_frequency'
    t.string 'state'
    t.string 'timezone_id'
    t.string 'timezone_name'
    t.boolean 'location_enabled', default: true, null: false
  end

  create_table 'system_configs', force: :cascade do |t|
    t.string 'key'
    t.string 'value'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'password_digest'
    t.string 'first_name'
    t.string 'last_name'
    t.string 'remember_token'
    t.string 'company'
    t.string 'activation_code'
    t.string 'state', default: 'active'
    t.string 'phone_number'
    t.boolean 'admin',                 default: false
    t.boolean 'force_password_change', default: false, null: false
    t.string 'account_id'
  end

  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['remember_token'], name: 'index_users_on_remember_token', using: :btree
end
