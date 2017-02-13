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

ActiveRecord::Schema.define(version: 20170213061546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.integer  "enquiry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enquiry_id"], name: "index_bookings_on_enquiry_id", using: :btree
  end

  create_table "enquiries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "freelancer_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "description"
    t.integer  "price"
    t.string   "status",        default: "open"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["freelancer_id"], name: "index_enquiries_on_freelancer_id", using: :btree
    t.index ["user_id"], name: "index_enquiries_on_user_id", using: :btree
  end

  create_table "freelancers", force: :cascade do |t|
    t.string   "profession"
    t.text     "description"
    t.datetime "start_working_hours"
    t.datetime "end_working_hours"
    t.text     "picture"
    t.integer  "user_id"
    t.integer  "price_start"
    t.integer  "price_end"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["user_id"], name: "index_freelancers_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "phone"
    t.string   "address"
    t.string   "profile_picture"
    t.integer  "email_confirmed", default: 0
    t.string   "confirm_token"
    t.integer  "reset_confirmed", default: 0
    t.string   "reset_token"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "bookings", "enquiries"
  add_foreign_key "enquiries", "freelancers"
  add_foreign_key "enquiries", "users"
  add_foreign_key "freelancers", "users"
end
