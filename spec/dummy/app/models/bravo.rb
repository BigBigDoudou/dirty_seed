class Bravo < ApplicationRecord
  validates :a_string, length: { minimum: 5 }
  validates :an_integer, numericality: { greater_than: 1_000 }
  validates :a_unique_value, uniqueness: true, numericality: { in: 1..2 }, allow_nil: true
  validates :a_string_from_options, inclusion: { in: %w[foo bar zed] }
  validates :an_integer_from_options, inclusion: { in: [15, 30, 45] }
  validates :an_absent_value, absence: true
  validates :a_regex, format: { with: /\w{10}@(hotmail|gmail)\.com/ }

  def attr_test
    attribute(:integer)
  end
end
