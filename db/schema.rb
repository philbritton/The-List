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
# It's strongly recommended to check this file into your version control system.


ActiveRecord::Schema.define(:version => 20130106071956) do
ActiveRecord::Schema.define(:version => 20130106071835) do

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.string   "user"
    t.integer  "post_id"
    t.integer  "comment_id"
    t.integer  "parent_id"
    t.integer  "upvote"
    t.integer  "downvote"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "text"
    t.string   "user"
    t.integer  "upvote"
    t.integer  "downvote"
    t.integer  "comment_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "username"
    t.integer  "good_karma"
    t.integer  "bad_karma"
  end

  add_index "users", ["bad_karma"], :name => "index_users_on_bad_karma"
  add_index "users", ["good_karma"], :name => "index_users_on_good_karma"
  add_index "users", ["username"], :name => "index_users_on_username"

end
