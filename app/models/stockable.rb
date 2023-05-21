class Stockable < ApplicationRecord
    belongs_to :stockable, polymorphic: true
    belongs_to :stock
  end