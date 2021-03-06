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

ActiveRecord::Schema.define(version: 20180321153359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.bigint "table_id"
    t.string "status", default: "unpaid"
    t.integer "balance_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_bills_on_table_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "category"
    t.bigint "restaurant_id"
    t.string "name"
    t.text "description"
    t.string "photo"
    t.integer "price_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "dish_id"
    t.bigint "bill_id"
    t.bigint "user_id"
    t.integer "quantity", default: 1
    t.string "status", default: "pending"
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "payment"
    t.bigint "picking_user_id"
    t.index ["bill_id"], name: "index_orders_on_bill_id"
    t.index ["dish_id"], name: "index_orders_on_dish_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.string "logo"
    t.string "photo"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_restaurants_on_user_id"
  end

  create_table "tables", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "status", default: "available"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_tables_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "restaurant_owner", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bills", "tables"
  add_foreign_key "dishes", "restaurants"
  add_foreign_key "orders", "bills"
  add_foreign_key "orders", "dishes"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "users", column: "picking_user_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "restaurants", "users"
  add_foreign_key "tables", "restaurants"
end
