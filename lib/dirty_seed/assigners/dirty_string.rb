# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a String matching validators
    class DirtyString < DirtyAssigner
      # Returns a string matching all validators
      # @return [String]
      def value
        ::Faker::Lorem.sentence(word_count: 3 + sequence % 2)
      end
    end
  end
end
