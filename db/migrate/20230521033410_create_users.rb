class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :primary_key do |t|
      t.string :email
      t.string :username
      t.string :password
      t.string :password_digest

      t.timestamps
    end
  end
end
