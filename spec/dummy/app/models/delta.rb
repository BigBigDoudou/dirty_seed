class Delta < ApplicationRecord
  belongs_to :bravo
  belongs_to :zed, class_name: 'Charlie', foreign_key: :zed_id
end
