class Alfa < ApplicationRecord
  has_one :delta
  has_many :echos, as: :echoable
  has_many :julietts

  after_initialize do |alfa|
    raise StandardError if alfa.a_string == '39763e57-f8a0-483a-8b26-cc670de8cbfd'
  end

  before_save do |alfa|
    raise StandardError if alfa.a_string == '5ecb793c-e0fd-4315-b60d-66f34c1c17e3'
  end
end
