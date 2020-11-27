# frozen_string_literal: true

module DirtySeed
  module Assigners
    module Type
      # Manages integer assignments
      class Integer < Assigner
        include FakerHelper
        include MinMaxHelper

        # Returns a random integer matching validators
        # @return [Integer]
        # @note `min` and `max` are defined in MinMaxHelper
        def value
          faker_value(
            generator: :Number,
            method: :between,
            options: { from: min, to: max }
          )
        end
      end
    end
  end
end
