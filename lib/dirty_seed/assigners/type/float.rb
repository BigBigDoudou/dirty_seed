# frozen_string_literal: true

module DirtySeed
  module Assigners
    module Type
      # Manages float assignments
      class Float < Assigner
        include FakerHelper
        include MinMaxHelper

        # Returns a random float matching validators
        # @return [Float]
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
