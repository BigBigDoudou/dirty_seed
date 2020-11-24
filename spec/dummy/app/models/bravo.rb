class Bravo < ApplicationRecord
  validates :integer, numericality: { greater_than: 1_000 }
  validates :integer, uniqueness: true

  def attr_test
    attribute(:integer)
  end
end
