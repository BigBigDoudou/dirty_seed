# frozen_string_literal: true

module DirtySeed
  module Assigners
    module Type
      # Manages json assignments
      class Json < Assigner
        include FakerHelper

        # Returns a random hash
        # @return [Hash]
        def value
          Hash[
            *Array.new(4) do
              faker_value(
                generator: :Lorem,
                method: :word
              )
            end
          ]
        end
      end
    end
  end
end
