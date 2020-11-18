# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a Time matching validators
    class DirtyTime < DirtyAssigner
      # Returns a time matching all validators
      # @return [Time]
      def value
        ::Faker::Time.between(from: DateTime.now - 42, to: DateTime.now + 42)
      end
    end
  end
end
