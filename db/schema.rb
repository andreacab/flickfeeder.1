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

ActiveRecord::Schema.define(version: 20160523195700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_settings", force: true do |t|
    t.boolean  "dashboard",      default: true
    t.boolean  "events",         default: true
    t.boolean  "devices_health", default: true
    t.boolean  "photo_stream",   default: true
    t.boolean  "team",           default: true
    t.boolean  "image_design",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "device_healths", force: true do |t|
    t.string   "current_battery_charge"
    t.integer  "f_fdevice_id"
    t.string   "available_storage"
    t.string   "health"
    t.string   "network_signal"
    t.string   "available_mobile_data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "device_healths", ["f_fdevice_id"], name: "index_device_healths_on_f_fdevice_id", using: :btree
  add_index "device_healths", ["user_id"], name: "index_device_healths_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["organization_id"], name: "index_events_on_organization_id", using: :btree

  create_table "events_labels", force: true do |t|
    t.integer "event_id"
    t.integer "label_id"
  end

  add_index "events_labels", ["event_id"], name: "index_events_labels_on_event_id", using: :btree
  add_index "events_labels", ["label_id"], name: "index_events_labels_on_label_id", using: :btree

  create_table "f_fdevices", force: true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "f_fdevices", ["organization_id"], name: "index_f_fdevices_on_organization_id", using: :btree
  add_index "f_fdevices", ["user_id"], name: "index_f_fdevices_on_user_id", using: :btree

  create_table "labels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels_medias", force: true do |t|
    t.integer "label_id"
    t.integer "media_id"
  end

  add_index "labels_medias", ["label_id"], name: "index_labels_medias_on_label_id", using: :btree
  add_index "labels_medias", ["media_id"], name: "index_labels_medias_on_media_id", using: :btree

  create_table "medias", force: true do |t|
    t.string   "type_of_media"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "event_id"
    t.string   "url"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medias", ["event_id"], name: "index_medias_on_event_id", using: :btree
  add_index "medias", ["organization_id"], name: "index_medias_on_organization_id", using: :btree
  add_index "medias", ["user_id"], name: "index_medias_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "account_type"
    t.string   "organization_type"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tokens", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "avatar_url"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "user_type"
    t.integer  "organization_id"
    t.string   "phone"
    t.string   "dropbox_access_token"
    t.string   "dropbox_user_id"
    t.string   "dropbox_cursor"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
