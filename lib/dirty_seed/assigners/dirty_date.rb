# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a Date matching validators
    class DirtyDate < DirtyAssigner
      # Returns a date matching all validators
      # @return [Date]
      def value
        ::Faker::Date.between(from: 42.days.ago, to: 42.days.from_now)
      end
    end
  end
end
