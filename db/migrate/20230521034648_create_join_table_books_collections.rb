class CreateJoinTableBooksCollections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :books, :collections do |t|
      t.index [:book_id, :collection_id]
      t.index [:collection_id, :book_id]
      t.boolean :is_active
      t.integer :current_page
      # t.references :book, null: false, foreign_key: { on_delete: :nullify, on_update: :cascade }
      # t.references :collection, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.timestamps
    end
  end
end
