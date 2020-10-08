class Juliet < ApplicationRecord
  belongs_to :alfa

  validate :custom_alfa_validation
  validate :custom_string_validation
  validate :custom_integer_validation

  private

  def custom_alfa_validation
    errors.add(:alfa, 'should be some specific alfa')
  end

  def custom_string_validation
    errors.add(:string, 'should be a specific string')
  end

  def custom_integer_validation
    errors.add(:integer, 'should be a specific integer')
  end
end
