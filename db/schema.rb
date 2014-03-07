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

ActiveRecord::Schema.define(version: 20140307225523) do

  create_table "auto_responders", force: true do |t|
    t.string   "matcher"
    t.string   "message"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auto_responders", ["enabled"], name: "index_auto_responders_on_enabled"

  create_table "providers", force: true do |t|
    t.boolean  "expires"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.string   "token"
    t.string   "refresh_token"
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "providers", ["user_id"], name: "index_providers_on_user_id"

  create_table "tweets", force: true do |t|
    t.string   "key"
    t.string   "account"
    t.string   "message"
    t.string   "answer_url"
    t.string   "agent_account"
    t.string   "customer_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "success",          default: false
    t.string   "status_id"
    t.integer  "answer_status_id"
  end

  add_index "tweets", ["answer_status_id"], name: "index_tweets_on_answer_status_id"
  add_index "tweets", ["key"], name: "index_tweets_on_key", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "birthday"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
