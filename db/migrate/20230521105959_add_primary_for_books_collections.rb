class AddPrimaryForBooksCollections < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TABLE books_collections
      ADD PRIMARY KEY (book_id, collection_id);
    SQL
  end
end
