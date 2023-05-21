class AddForeignKeyToTransactionsBooks < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :books_transactions, :books, index: true, on_delete: :nullify, on_update: :cascade
    add_foreign_key :books_transactions, :transactions, index: true, on_delete: :nullify, on_update: :cascade
  end
end
