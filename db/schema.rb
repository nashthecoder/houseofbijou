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

ActiveRecord::Schema[8.1].define(version: 2026_08_24_080500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "aid_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "deadline"
    t.string "status"
    t.integer "target_amount"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "phone"
    t.integer "position"
    t.string "relationship"
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.string "color", default: "#c29765"
    t.datetime "created_at", null: false
    t.integer "position", default: 0
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "sender"
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
  end

  create_table "panic_alerts", force: :cascade do |t|
    t.integer "contacts_notified"
    t.datetime "created_at", null: false
    t.string "delivered_via"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "reviewed_at"
    t.string "sms_status"
    t.datetime "updated_at", null: false
  end

  create_table "pledges", force: :cascade do |t|
    t.bigint "aid_request_id", null: false
    t.integer "amount"
    t.datetime "created_at", null: false
    t.string "helper_name"
    t.string "kind"
    t.string "note"
    t.datetime "updated_at", null: false
    t.index ["aid_request_id"], name: "index_pledges_on_aid_request_id"
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "alerts_reviewed_at"
    t.string "avatar_color", default: "#c29765"
    t.integer "chat_timer_minutes"
    t.datetime "created_at", null: false
    t.string "disguise"
    t.string "disguise_accent"
    t.boolean "high_contrast"
    t.string "pin_digest"
    t.string "pseudonym"
    t.string "recovery_email"
    t.integer "text_scale"
    t.datetime "updated_at", null: false
    t.datetime "values_accepted_at"
  end

  create_table "stories", force: :cascade do |t|
    t.string "author", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visibility", default: "circle", null: false
  end

  create_table "vote_proposals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "supports_count"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "messages", "conversations"
  add_foreign_key "pledges", "aid_requests"
end
