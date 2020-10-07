class Charlie < ApplicationRecord
  belongs_to :alfa
  has_many :deltas
  has_many :echos, as: :echoable
end
