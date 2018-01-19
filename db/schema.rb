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

ActiveRecord::Schema.define(version: 20161004204032) do

  create_table "days", force: :cascade do |t|
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "day_notes"
  end

  create_table "pickups", force: :cascade do |t|
    t.integer "day_id"
    t.string "donor_title"
    t.string "donor_first_name"
    t.string "donor_last_name"
    t.string "donor_spouse_name"
    t.string "donor_address_line1"
    t.string "donor_address_line2"
    t.string "donor_city"
    t.string "donor_zip"
    t.string "donor_dwelling_type"
    t.string "donor_phone"
    t.string "donor_email"
    t.integer "number_of_items"
    t.text "item_notes"
    t.text "donor_notes"
    t.boolean "rejected", default: false
    t.string "rejected_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "donor_state"
    t.boolean "send_email", default: false
    t.string "pickup_label"
    t.string "pickup_label_color"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "username"
    t.integer "permission_level", default: 0
    t.boolean "super_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
