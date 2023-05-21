class Highlight < ApplicationRecord
    
    validates :x, presence: true
    validates :y, presence: true
    validates :width, presence: true
    validates :height, presence: true
    validates :comment, presence: true
    validates :page, presence: true
    validates :page_width, presence: true
    validates :page_height, presence: true
    belongs_to :book
    belongs_to :user

end