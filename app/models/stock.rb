class Stock < ApplicationRecord
    
    validates :name, presence: true
    validates :location, presence: true
    has_many :stockables
    has_many :books, through: :stockables, source: :stockable, source_type: 'Book'



end