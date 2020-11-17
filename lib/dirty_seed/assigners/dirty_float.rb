# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws an Float matching validators
    class DirtyFloat < DirtyAssigner
      # Returns a float matching all validators
      # @return [Float]
      def value
        integer + decimals
      end

      private

      # Returns an Integer matching all validators
      # @return [Integer]
      def integer
        DirtySeed::Assigners::DirtyInteger.new(attribute: attribute).value
      end

      # Returns a Float between 0 and 1
      # @return [Float]
      def decimals
        rand(0..Float(1))
      end
    end
  end
end
