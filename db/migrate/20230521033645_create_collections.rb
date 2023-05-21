class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections, id: :primary_key do |t|
      t.string :name
      t.boolean :is_public
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }

      t.timestamps


    end
  end
end
