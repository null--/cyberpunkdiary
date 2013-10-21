# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131021110912) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "abstract"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",       :default => 0
    t.integer  "leet",       :default => 0
    t.integer  "lame",       :default => 0
    t.integer  "icon",       :default => 0
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "article_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infos", :force => true do |t|
    t.string   "title"
    t.string   "about"
    t.string   "bug_report"
    t.integer  "total_hits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.integer "article_id"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "nickname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
    t.integer  "priv",       :default => 0
  end

# Could not dump table "votes" because of following StandardError
#   Unknown type 'reference' for column 'article_id'

end
