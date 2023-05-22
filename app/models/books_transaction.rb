class BooksTransaction < ApplicationRecord
    belongs_to :transaction_model, class_name: 'Transaction', foreign_key: :transaction_id
    belongs_to :book
    belongs_to :stock, optional: true
end
