class Alfa < ApplicationRecord
  has_one :delta
  has_many :echos, as: :echoable
  has_many :julietts
end
