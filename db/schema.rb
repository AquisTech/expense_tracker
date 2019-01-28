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

ActiveRecord::Schema.define(version: 2019_01_28_220959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_balances", force: :cascade do |t|
    t.integer "opening_balance", default: 0
    t.integer "calculated_closing_balance", default: 0
    t.integer "actual_closing_balance", default: 0
    t.integer "month", null: false
    t.integer "year", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["account_id"], name: "index_account_balances_on_account_id"
    t.index ["user_id"], name: "index_account_balances_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "details"
    t.string "account_type"
    t.text "payment_modes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "occurrences", force: :cascade do |t|
    t.string "recurrence_type"
    t.integer "interval"
    t.integer "days"
    t.integer "weeks"
    t.integer "months"
    t.datetime "starts_on"
    t.datetime "ends_on"
    t.integer "count"
    t.bigint "recurrence_rule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["recurrence_rule_id"], name: "index_occurrences_on_recurrence_rule_id"
    t.index ["user_id"], name: "index_occurrences_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount", default: 0
    t.string "payment_mode"
    t.bigint "transaction_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["transaction_id"], name: "index_payments_on_transaction_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "recurrence_rules", force: :cascade do |t|
    t.string "type"
    t.integer "interval"
    t.datetime "starts_on"
    t.datetime "ends_on"
    t.integer "count"
    t.text "rules"
    t.bigint "transaction_purpose_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["transaction_purpose_id"], name: "index_recurrence_rules_on_transaction_purpose_id"
    t.index ["user_id"], name: "index_recurrence_rules_on_user_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "transaction_purposes", force: :cascade do |t|
    t.string "name"
    t.integer "estimate", default: 0
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["sub_category_id"], name: "index_transaction_purposes_on_sub_category_id"
    t.index ["user_id"], name: "index_transaction_purposes_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount", default: 0
    t.string "description"
    t.bigint "transaction_purpose_id", null: false
    t.bigint "transfer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "transacted_at", null: false
    t.bigint "user_id"
    t.index ["transaction_purpose_id"], name: "index_transactions_on_transaction_purpose_id"
    t.index ["transfer_id"], name: "index_transactions_on_transfer_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.integer "amount", default: 0
    t.string "description"
    t.bigint "source_account_id", null: false
    t.bigint "destination_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["destination_account_id"], name: "index_transfers_on_destination_account_id"
    t.index ["source_account_id"], name: "index_transfers_on_source_account_id"
    t.index ["user_id"], name: "index_transfers_on_user_id"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "occurrences", "recurrence_rules"
  add_foreign_key "recurrence_rules", "transaction_purposes"
end
