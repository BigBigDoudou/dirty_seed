# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_23_100337) do

  create_table "alfas", force: :cascade do |t|
    t.boolean "a_boolean"
    t.integer "an_integer"
    t.decimal "a_decimal"
    t.string "a_string"
    t.date "a_date"
    t.time "a_time"
    t.datetime "a_datetime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bravos", force: :cascade do |t|
    t.boolean "a_boolean", default: false, null: false
    t.integer "an_integer", null: false
    t.decimal "a_decimal", null: false
    t.string "a_string", null: false
    t.integer "a_unique_value"
    t.string "a_string_from_options"
    t.integer "an_integer_from_options"
    t.string "an_absent_value"
    t.string "a_regex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "charlies", force: :cascade do |t|
    t.integer "alfa_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alfa_id"], name: "index_charlies_on_alfa_id"
  end

  create_table "deltas", force: :cascade do |t|
    t.integer "bravo_id", null: false
    t.integer "zed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bravo_id"], name: "index_deltas_on_bravo_id"
    t.index ["zed_id"], name: "index_deltas_on_zed_id"
  end

  create_table "echos", force: :cascade do |t|
    t.string "echoable_type"
    t.integer "echoable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["echoable_type", "echoable_id"], name: "index_echos_on_echoable_type_and_echoable_id"
  end

  create_table "foxtrots", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hotels", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "india_id"
    t.index ["india_id"], name: "index_hotels_on_india_id"
  end

  create_table "indias", force: :cascade do |t|
    t.integer "hotel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hotel_id"], name: "index_indias_on_hotel_id"
  end

  create_table "julietts", force: :cascade do |t|
    t.integer "alfa_id", null: false
    t.string "a_string"
    t.integer "an_integer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alfa_id"], name: "index_julietts_on_alfa_id"
  end

  create_table "kilos", force: :cascade do |t|
    t.string "type"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.string "reset_password_sent_at"
    t.string "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "charlies", "alfas"
  add_foreign_key "deltas", "bravos"
  add_foreign_key "deltas", "charlies", column: "zed_id"
  add_foreign_key "hotels", "indias"
  add_foreign_key "indias", "hotels"
  add_foreign_key "julietts", "alfas"
end
