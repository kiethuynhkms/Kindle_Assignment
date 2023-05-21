class Transaction < ApplicationRecord
    
    belongs_to :user
    validates :total, presence: true
    has_many :books_transactions
    has_many :books, through: :books_transactions

end