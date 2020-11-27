# frozen_string_literal: true

module DirtySeed
  module Assigners
    module Type
      # Manages boolean assignments
      class Boolean < Assigner
        # Returns a random boolean
        # @return [Boolean]
        def value
          [true, false].sample
        end
      end
    end
  end
end
