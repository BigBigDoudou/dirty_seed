# frozen_string_literal: true

module DirtySeed
  module Assigners
    module Type
      # Manages date assignments
      class Date < Assigner
        include FakerHelper

        # Returns a random date matching validators
        # @return [Date]
        def value
          faker_value(
            generator: :Date,
            method: :between,
            options: { from: 42.days.ago, to: 42.days.from_now }
          )
        end
      end
    end
  end
end
