class Bravo < ApplicationRecord
  validates :integer, numericality: { greater_than: 1_000 }
end
