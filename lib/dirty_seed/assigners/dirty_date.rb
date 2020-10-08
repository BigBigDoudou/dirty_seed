# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws a Date matching validators
    class DirtyDate < DirtyAssigner
      # returns a Date matching all validators
      def value
        ::Faker::Date.between(from: 2.years.ago, to: 2.years.from_now)
      end
    end
  end
end
