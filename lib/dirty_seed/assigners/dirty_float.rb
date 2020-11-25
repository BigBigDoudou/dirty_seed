# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws an Float matching validators
    class DirtyFloat < DirtyNumber
      # Returns a value matching all validators
      # @return [Float]
      def define_value
        super
        faker_value(
          category: :Number,
          method: :between,
          options: { from: min, to: max - 1 }
        ) + decimals
      end

      private

      # Returns a value between 0 and 1
      # @return [Float]
      def decimals
        rand(0..Float(1))
      end

      # Defines the gap to add to min when "greater_than" or to substract to max when "less_than"
      #   For example if value should be greater_than 0, then the min is 0.01
      #   and if the value should be lesser_than 1, then the max is 0.99
      # @return [Float]
      def gap
        0.01
      end
    end
  end
end
