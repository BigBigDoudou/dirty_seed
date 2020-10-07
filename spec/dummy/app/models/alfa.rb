class Alfa < ApplicationRecord
  has_one :delta
  has_many :echos, as: :echoable
end
