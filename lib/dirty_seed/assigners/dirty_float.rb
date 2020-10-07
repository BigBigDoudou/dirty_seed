# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws an Float matching validators
    class DirtyFloat < DirtyAssigner
      # returns a Float matching all validators
      def value
        integer + decimals
      end

      private

      # returns an Integer matching all validators
      def integer
        DirtySeed::Assigners::DirtyInteger.new(
          validators: validators, sequence: sequence
        ).value
      end

      # returns a Float between 0 and 1
      def decimals
        rand(0..Float(1))
      end
    end
  end
end
