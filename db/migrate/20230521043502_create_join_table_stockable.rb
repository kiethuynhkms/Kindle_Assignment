class CreateJoinTableStockable < ActiveRecord::Migration[7.0]
  def change
    create_table :stockables do |t|
      t.references :stockable, polymorphic: true, null: false
      t.references :stock, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.integer :amount, null: false

      t.timestamps
    end

    add_index :stockables, [:stockable_id, :stockable_type, :stock_id], unique: true, name: 'index_stockables_on_ids_and_stock_id'
  end
end
