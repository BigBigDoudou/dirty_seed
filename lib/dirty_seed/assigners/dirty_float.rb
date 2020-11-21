# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws an Float matching validators
    class DirtyFloat < DirtyAssigner
      # Returns a value matching all validators
      # @return [Float]
      def value
        integer + decimals
      end

      private

      # Returns a value matching all validators
      # @return [Integer]
      def integer
        DirtySeed::Assigners::DirtyInteger.new(dirty_attribute, 0).value
      end

      # Returns a value between 0 and 1
      # @return [Float]
      def decimals
        rand(0..Float(1))
      end
    end
  end
end
