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

ActiveRecord::Schema.define(version: 20140330210710) do

  create_table "akords", force: true do |t|
    t.string   "nazwa"
    t.string   "obrazek"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "akords", ["nazwa"], name: "nazwa", using: :btree

  create_table "piosenka_akords", id: false, force: true do |t|
    t.integer "piosenka_id", default: 0, null: false
    t.integer "akord_id",    default: 0, null: false
  end

  create_table "piosenka_akords_tmp", id: false, force: true do |t|
    t.integer "piosenka_id"
    t.integer "akord_id"
  end

  create_table "piosenkas", force: true do |t|
    t.string   "tytul"
    t.text     "tekst"
    t.text     "akordy"
    t.string   "wykonawca"
    t.string   "obrazek"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: false, null: false
  end

  add_index "piosenkas", ["active"], name: "active", using: :btree
  add_index "piosenkas", ["tytul"], name: "tytul", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "email"
    t.string   "active",          limit: 1, default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.boolean  "admin",                     default: false
    t.boolean  "moderator",                 default: false
  end

  add_index "users", ["email"], name: "email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
