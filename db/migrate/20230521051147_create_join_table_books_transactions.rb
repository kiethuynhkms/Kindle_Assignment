class CreateJoinTableBooksTransactions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :transactions, :books do |t|
      t.index [:book_id, :transaction_id]
      t.index [:transaction_id, :book_id]
      t.integer :quantity
      t.references :stock, foreign_key: { on_delete: :nullify, on_update: :cascade }
    end
  end
end
