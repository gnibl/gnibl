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

ActiveRecord::Schema.define(:version => 20130925183540) do

  create_table "add_secretcode_to_users", :force => true do |t|
    t.string   "secretcode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "city_name"
    t.string   "country_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "gnib_id"
    t.integer  "replyto_id"
    t.string   "description"
    t.integer  "votes"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "gniblings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "gnib_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "count"
  end

  create_table "gnibs", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "landmark"
    t.string   "description"
    t.integer  "visibility"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "city"
    t.string   "imageurl"
    t.string   "link"
    t.boolean  "video"
  end

  add_index "gnibs", ["user_id", "created_at"], :name => "index_gnibs_on_user_id_and_created_at"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "gnib_id"
    t.string   "message"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "read",        :default => false
    t.integer  "gnib_action"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "reporteds", :force => true do |t|
    t.integer  "gnib_id"
    t.integer  "reporter_id"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "upvotegnibs", :force => true do |t|
    t.integer  "gnib_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "email"
    t.string   "city"
    t.string   "avatar"
    t.string   "description"
    t.string   "username"
    t.string   "surname"
    t.datetime "birthday"
    t.integer  "city_id"
    t.boolean  "validated"
    t.string   "validation_code"
    t.string   "emailsecret"
    t.string   "secretcode"
  end

end
