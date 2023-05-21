class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :primary_key do |t|
      t.references :user, null: false, foreign_key: { on_delete: :nullify, on_update: :cascade }
      t.float :total

      t.timestamps
    end
  end
end
