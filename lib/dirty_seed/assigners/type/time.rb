# frozen_string_literal: true

module DirtySeed
  module Assigners
    module Type
      # Manages time assignments
      class Time < Assigner
        include FakerHelper

        # Returns a random time matching validators
        # @return [Time]
        def value
          ::Faker::Time.between(from: DateTime.now - 42, to: DateTime.now + 42)
        end
      end
    end
  end
end
