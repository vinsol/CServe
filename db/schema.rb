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

ActiveRecord::Schema.define(version: 20150224060003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "company_id"
    t.boolean  "enabled",                            default: true
    t.boolean  "company_admin",                      default: false
  end

  add_index "admins", ["company_id"], name: "index_admins_on_company_id", using: :btree
  add_index "admins", ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "admin_id"
    t.integer  "company_id"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "articles", ["admin_id"], name: "index_articles_on_admin_id", using: :btree
  add_index "articles", ["company_id"], name: "index_articles_on_company_id", using: :btree
  add_index "articles", ["description"], name: "index_articles_on_description", using: :btree
  add_index "articles", ["title"], name: "index_articles_on_title", using: :btree

  create_table "articles_categories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  add_index "articles_categories", ["article_id"], name: "index_articles_categories_on_article_id", using: :btree
  add_index "articles_categories", ["category_id"], name: "index_articles_categories_on_category_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer  "ticket_id",                         null: false
    t.string   "type",                  limit: 255
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["ticket_id"], name: "index_attachments_on_ticket_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "company_id"
    t.boolean  "enabled",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "categories", ["company_id"], name: "index_categories_on_company_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "text"
    t.integer  "ticket_id"
    t.string   "commenter_email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public"
  end

  add_index "comments", ["ticket_id"], name: "index_comments_on_ticket_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "subdomain",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "support_email"
    t.string   "confirmation_token"
  end

  add_index "companies", ["subdomain"], name: "index_companies_on_subdomain", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
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

  create_table "tickets", force: :cascade do |t|
    t.string   "email",       limit: 255
    t.string   "subject",     limit: 255
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
    t.string   "state",                   default: "unassigned"
    t.string   "unique_id"
  end

  add_index "tickets", ["admin_id"], name: "index_tickets_on_admin_id", using: :btree
  add_index "tickets", ["company_id"], name: "index_tickets_on_company_id", using: :btree
  add_index "tickets", ["email"], name: "index_tickets_on_email", using: :btree
  add_index "tickets", ["subject"], name: "index_tickets_on_subject", using: :btree

end
