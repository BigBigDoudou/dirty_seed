# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws an integer matching validators
    class Integer < Assigner
      include MinMaxHelper

      # Returns an value matching all validators
      # @return [Integer]
      def value
        faker_value(
          category: :Number,
          method: :between,
          options: { from: min, to: max }
        )
      end
    end
  end
end
