# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws an Float matching validators
    class Float < Assigner
      include MinMaxHelper

      # Returns an value matching all validators
      # @return [Float]
      def value
        # binding.pry
        faker_value(
          category: :Number,
          method: :between,
          options: { from: min, to: max }
        )
      end
    end
  end
end
