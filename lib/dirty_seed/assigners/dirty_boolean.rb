# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a boolean value matching validators
    class DirtyBoolean < DirtyAssigner
      # Returns a boolean
      # @return [Boolean]
      def value
        [true, false].sample
      end
    end
  end
end
