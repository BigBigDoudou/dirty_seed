# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class DirtyDate < DirtyAssigner
      # Returns a date matching all validators
      # @return [Date]
      def define_value
        faker_value(
          category: :Date,
          method: :between,
          options: { from: 42.days.ago, to: 42.days.from_now }
        )
      end
    end
  end
end
