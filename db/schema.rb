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

ActiveRecord::Schema.define(version: 20150512005023) do

  create_table "acm300_logs", force: :cascade do |t|
    t.string   "acm_module", limit: 255
    t.date     "log_date"
    t.datetime "log_time"
    t.float    "vin",        limit: 24
    t.float    "iin",        limit: 24
    t.float    "vout",       limit: 24
    t.float    "iout",       limit: 24
    t.float    "power",      limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "flukes", force: :cascade do |t|
    t.datetime "log_time"
    t.integer  "off",        limit: 4
    t.string   "irr_py1",    limit: 255
    t.string   "irr_py2",    limit: 255
    t.string   "irr_rc1",    limit: 255
    t.string   "temp_rc1",   limit: 255
    t.string   "irr_rc2",    limit: 255
    t.string   "temp_rc2",   limit: 255
    t.string   "flowrate",   limit: 255
    t.string   "temp_pv1",   limit: 255
    t.string   "temp_pv2",   limit: 255
    t.string   "temp_pv3",   limit: 255
    t.string   "temp_pv4",   limit: 255
    t.string   "temp_pv5",   limit: 255
    t.string   "temp_pv6",   limit: 255
    t.string   "temp_hxi",   limit: 255
    t.string   "temp_hxo",   limit: 255
    t.string   "temp_amb",   limit: 255
    t.string   "temp_bbox",  limit: 255
    t.string   "temp_wtt",   limit: 255
    t.string   "temp_wtb",   limit: 255
    t.string   "tempC",      limit: 255
    t.float    "total",      limit: 24
    t.integer  "dioalarm",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "temp_bpst",  limit: 255
  end

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",            limit: 255, null: false
    t.string   "crypted_password", limit: 255
    t.string   "salt",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
