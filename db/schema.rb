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

ActiveRecord::Schema.define(version: 2021_02_28_023135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "autoresponder_logs", force: :cascade do |t|
    t.bigint "autoresponder_id", null: false
    t.text "message"
    t.string "checksum"
    t.datetime "created_at"
    t.index ["autoresponder_id"], name: "index_autoresponder_logs_on_autoresponder_id"
    t.index ["checksum"], name: "index_autoresponder_logs_on_checksum"
  end

  create_table "autoresponders", force: :cascade do |t|
    t.string "response_type", null: false
    t.boolean "active", default: false, null: false
    t.datetime "status_changed_at"
    t.text "message", null: false
    t.datetime "created_at"
    t.index ["response_type"], name: "index_autoresponders_on_response_type"
  end

  create_table "chat_access_keys", force: :cascade do |t|
    t.string "access_key", null: false
    t.string "access_key_salt", null: false
    t.integer "accessed", default: 0, null: false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "visitor_id", null: false
    t.string "identifier", null: false
    t.datetime "created_at"
    t.datetime "closed_at"
    t.index ["closed_at"], name: "index_conversations_on_closed_at"
    t.index ["created_at"], name: "index_conversations_on_created_at"
    t.index ["identifier"], name: "index_conversations_on_identifier", unique: true
    t.index ["user_id"], name: "index_conversations_on_user_id"
    t.index ["visitor_id"], name: "index_conversations_on_visitor_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.string "messageable_type", null: false
    t.bigint "messageable_id", null: false
    t.text "message", null: false
    t.datetime "created_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable_type_and_messageable_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string "twilio_sid"
    t.string "name", null: false
    t.string "number", null: false
    t.jsonb "details", default: {}, null: false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "access_token", null: false
    t.boolean "change_password"
    t.jsonb "cached_user"
    t.datetime "created_at"
    t.index ["access_token"], name: "index_sessions_on_access_token"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_login_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at"
    t.index ["user_id"], name: "index_user_login_entries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.string "identifier", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "new_email"
    t.string "password_digest", null: false
    t.string "password_change", default: "f", null: false
    t.string "perishable_token"
    t.string "time_zone"
    t.string "user_status"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["identifier"], name: "index_users_on_identifier", unique: true
    t.index ["user_status"], name: "index_users_on_user_status"
  end

  create_table "visitors", force: :cascade do |t|
    t.string "identifier", null: false
    t.bigint "user_id", null: false
    t.string "fake_name", null: false
    t.string "to_number"
    t.string "from_number"
    t.string "chat_window_status"
    t.json "properties", default: {}
    t.datetime "created_at"
    t.index ["identifier"], name: "index_visitors_on_identifier", unique: true
    t.index ["user_id"], name: "index_visitors_on_user_id"
  end

  create_table "webhook_entries", force: :cascade do |t|
    t.text "data"
    t.datetime "created_at"
  end

  add_foreign_key "autoresponder_logs", "autoresponders"
  add_foreign_key "conversations", "users"
  add_foreign_key "conversations", "visitors"
  add_foreign_key "messages", "conversations"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_login_entries", "users"
  add_foreign_key "visitors", "users"
end
