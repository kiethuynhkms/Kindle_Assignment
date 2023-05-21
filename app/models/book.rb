class Book < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    has_many :books_collections
    has_many :collections, through: :books_collections
    has_many :highlights
    has_many :books_transactions
    has_many :transactions, through: :books_transactions
    has_many :stockables, as: :stockable
    has_many :stocks, through: :stockables

end





