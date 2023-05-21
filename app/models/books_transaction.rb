class BooksTransaction < ApplicationRecord
    belongs_to :transaction_model, class_name: 'Transaction'
    belongs_to :book
    belongs_to :stock, optional: true
end
