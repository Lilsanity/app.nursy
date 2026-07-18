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

ActiveRecord::Schema[8.1].define(version: 2026_07_18_070152) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.string "address"
    t.bigint "availability_id", null: false
    t.string "care_type"
    t.datetime "created_at", null: false
    t.bigint "nurse_id", null: false
    t.float "price"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["availability_id"], name: "index_appointments_on_availability_id"
    t.index ["nurse_id"], name: "index_appointments_on_nurse_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.boolean "is_booked"
    t.bigint "nurse_id", null: false
    t.datetime "start_time"
    t.datetime "updated_at", null: false
    t.index ["nurse_id"], name: "index_availabilities_on_nurse_id"
  end

  create_table "communes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "name"
    t.string "postal_code"
    t.datetime "updated_at", null: false
  end

  create_table "nurse_specialties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "nurse_id", null: false
    t.bigint "specialty_id", null: false
    t.datetime "updated_at", null: false
    t.index ["nurse_id"], name: "index_nurse_specialties_on_nurse_id"
    t.index ["specialty_id"], name: "index_nurse_specialties_on_specialty_id"
  end

  create_table "nurses", force: :cascade do |t|
    t.float "average_rating"
    t.bigint "commune_id", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.boolean "is_verified"
    t.string "last_name"
    t.string "rpps_number"
    t.datetime "updated_at", null: false
    t.index ["commune_id"], name: "index_nurses_on_commune_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "nurse_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["appointment_id"], name: "index_reviews_on_appointment_id"
    t.index ["nurse_id"], name: "index_reviews_on_nurse_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "commune"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appointments", "availabilities"
  add_foreign_key "appointments", "nurses"
  add_foreign_key "appointments", "users"
  add_foreign_key "availabilities", "nurses"
  add_foreign_key "nurse_specialties", "nurses"
  add_foreign_key "nurse_specialties", "specialties"
  add_foreign_key "nurses", "communes"
  add_foreign_key "reviews", "appointments"
  add_foreign_key "reviews", "nurses"
  add_foreign_key "reviews", "users"
end
