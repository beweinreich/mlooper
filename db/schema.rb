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

ActiveRecord::Schema.define(version: 20160820231128) do

  create_table "conversations", force: :cascade do |t|
    t.string   "looped_with",    limit: 255
    t.string   "spammers_email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled",       limit: 1,   default: false, null: false
    t.integer  "user_id",        limit: 4
    t.string   "privacy",        limit: 7
    t.boolean  "featured",       limit: 1
    t.string   "name",           limit: 255
    t.integer  "hilarity",       limit: 4
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "emails", force: :cascade do |t|
    t.integer  "conversation_id",  limit: 4
    t.string   "to",               limit: 255
    t.string   "from",             limit: 255
    t.string   "direction",        limit: 255
    t.boolean  "needs_to_be_sent", limit: 1,     default: false, null: false
    t.string   "subject",          limit: 255
    t.text     "body",             limit: 65535
    t.text     "headers",          limit: 65535
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.text     "html",             limit: 65535
    t.datetime "send_at"
  end

  create_table "replacements", force: :cascade do |t|
    t.string   "word",             limit: 255
    t.string   "replacement_word", limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "replies", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "email",                  limit: 255, default: "",       null: false
    t.string   "looper_name",            limit: 255
    t.string   "looper_title",           limit: 255
    t.string   "encrypted_password",     limit: 255, default: "",       null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "privacy",                limit: 7,   default: "public"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
