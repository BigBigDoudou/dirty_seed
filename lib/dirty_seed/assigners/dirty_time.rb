# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws a Time matching validators
    class DirtyTime < DirtyAssigner
      # returns a Time matching all validators
      def value
        ::Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
      end
    end
  end
end
