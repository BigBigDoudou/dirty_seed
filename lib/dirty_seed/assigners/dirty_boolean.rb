# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws a boolean value matching validators
    class DirtyBoolean < DirtyAssigner
      # returns a Boolean
      def value
        [true, false].sample
      end
    end
  end
end
