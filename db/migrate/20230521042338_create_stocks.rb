class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks, id: :primary_key do |t|
      t.string :name
      t.string :location

      t.timestamps
    end
  end
end
