class Hotel < ApplicationRecord
  belongs_to :india, optional: true
  has_many :indias
end
