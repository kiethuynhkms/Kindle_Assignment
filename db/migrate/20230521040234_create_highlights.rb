class CreateHighlights < ActiveRecord::Migration[7.0]
  def change
    create_table :highlights do |t|
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height
      t.text :comment
      t.integer :page
      t.integer :page_width
      t.integer :page_height
      t.references :user, null: false, foreign_key: { on_delete: :nullify, on_update: :cascade }
      t.references :book, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }

      t.timestamps
    end
  end
end
