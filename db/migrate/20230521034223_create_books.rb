class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books, id: :primary_key do |t|
      t.string :title
      t.string :description
      t.string :image_cover_link
      t.string :type, null: false
      t.string :file_link
      t.float :price

      t.timestamps
    end
  end
end
