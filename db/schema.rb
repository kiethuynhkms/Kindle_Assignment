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

ActiveRecord::Schema[7.0].define(version: 2023_05_21_105959) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "image_cover_link"
    t.string "type", null: false
    t.string "file_link"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books_collections", primary_key: ["book_id", "collection_id"], force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "collection_id", null: false
    t.boolean "is_active"
    t.integer "current_page"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "collection_id"], name: "index_books_collections_on_book_id_and_collection_id"
    t.index ["collection_id", "book_id"], name: "index_books_collections_on_collection_id_and_book_id"
  end

  create_table "books_transactions", id: false, force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.bigint "book_id", null: false
    t.integer "quantity"
    t.bigint "stock_id"
    t.index ["book_id", "transaction_id"], name: "index_books_transactions_on_book_id_and_transaction_id"
    t.index ["stock_id"], name: "index_books_transactions_on_stock_id"
    t.index ["transaction_id", "book_id"], name: "index_books_transactions_on_transaction_id_and_book_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.boolean "is_public"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "highlights", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.integer "width"
    t.integer "height"
    t.text "comment"
    t.integer "page"
    t.integer "page_width"
    t.integer "page_height"
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_highlights_on_book_id"
    t.index ["user_id"], name: "index_highlights_on_user_id"
  end

  create_table "stockables", force: :cascade do |t|
    t.string "stockable_type", null: false
    t.bigint "stockable_id", null: false
    t.bigint "stock_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stockables_on_stock_id"
    t.index ["stockable_id", "stockable_type", "stock_id"], name: "index_stockables_on_ids_and_stock_id", unique: true
    t.index ["stockable_type", "stockable_id"], name: "index_stockables_on_stockable"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "books_collections", "books", on_update: :cascade, on_delete: :cascade
  add_foreign_key "books_collections", "collections", on_update: :cascade, on_delete: :cascade
  add_foreign_key "books_transactions", "books", on_update: :cascade, on_delete: :nullify
  add_foreign_key "books_transactions", "stocks", on_update: :cascade, on_delete: :nullify
  add_foreign_key "books_transactions", "transactions", on_update: :cascade, on_delete: :nullify
  add_foreign_key "collections", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "highlights", "books", on_update: :cascade, on_delete: :cascade
  add_foreign_key "highlights", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "stockables", "stocks", on_update: :cascade, on_delete: :cascade
  add_foreign_key "transactions", "users", on_update: :cascade, on_delete: :nullify
end
