# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws an integer matching validators
    class DirtyInteger < DirtyNumber
      # Defines the gap to add to min when "greater_than" or to substract to max when "less_than"
      #   For example if value should be greater_than 0, then the min is 1
      #   and if the value should be lesser_than 1_000, then the max is 999
      # @return [Integer]
      def gap
        1
      end
    end
  end
end
