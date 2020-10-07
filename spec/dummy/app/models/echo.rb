class Echo < ApplicationRecord
  belongs_to :echoable, polymorphic: true
end
