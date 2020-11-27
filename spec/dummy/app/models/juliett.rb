class Juliett < ApplicationRecord
  belongs_to :alfa

  validate :custom_alfa_validation
  validate :custom_string_validation
  validate :custom_integer_validation

  private

  def custom_alfa_validation
    errors.add(:alfa, 'should be specific')
  end

  def custom_string_validation
    errors.add(:a_string, 'should be specific')
  end

  def custom_integer_validation
    errors.add(:an_integer, 'should be specific')
  end
end
