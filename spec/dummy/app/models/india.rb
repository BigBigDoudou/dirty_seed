class India < ApplicationRecord
  belongs_to :hotel
  has_many :hotels
end
