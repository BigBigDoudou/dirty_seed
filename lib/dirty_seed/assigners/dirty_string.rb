# frozen_string_literal: true

require 'faker'

module DirtySeed
  module Assigners
    # draws a String matching validators
    class DirtyString < DirtyAssigner
      # returns a String matching all validators
      def value
        ::Faker::Lorem.sentence(word_count: 3 + sequence % 2)
      end
    end
  end
end
