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

ActiveRecord::Schema.define(version: 20161009110759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "messages", force: :cascade do |t|
    t.text   "text"
    t.string "link"
    t.string "password"
  end

  add_index "messages", ["link"], name: "index_messages_on_link", unique: true, using: :btree

  create_table "options", force: :cascade do |t|
    t.datetime "delete_at"
    t.integer  "delete_after_views"
    t.integer  "message_id"
  end

  add_index "options", ["message_id"], name: "index_options_on_message_id", using: :btree

  add_foreign_key "options", "messages"
end
