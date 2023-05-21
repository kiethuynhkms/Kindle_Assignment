class AddForeignKeyToBooksCollections < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :books_collections, :books, index: true, on_delete: :cascade, on_update: :cascade
    add_foreign_key :books_collections, :collections, index: true, on_delete: :cascade, on_update: :cascade
  end
end
