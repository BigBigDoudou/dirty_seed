# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class DirtyBoolean < DirtyAssigner
      # Returns a boolean
      # @return [Boolean]
      def value
        [true, false].sample
      end
    end
  end
end
