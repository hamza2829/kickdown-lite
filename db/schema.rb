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

ActiveRecord::Schema[8.1].define(version: 2026_10_09_000003) do
  create_table "bids", force: :cascade do |t|
    t.integer "listing_id", null: false
    t.string "bidder_name", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_bids_on_listing_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "listing_id", null: false
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id", "kind"], name: "index_events_on_listing_id_and_kind"
    t.index ["listing_id"], name: "index_events_on_listing_id"
  end

  create_table "listings", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "starting_price", null: false
    t.datetime "ends_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bids", "listings"
  add_foreign_key "events", "listings"
end
