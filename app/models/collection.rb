class Collection < ApplicationRecord
    
    validates :name, presence: true
    belongs_to :user
    has_many :books_collections
    has_many :books, through: :books_collections

    def as_json(options={})
        super(options).merge({ user: user, books: books })
    end



end