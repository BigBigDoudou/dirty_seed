# frozen_string_literal: true

module DirtySeed
  module Assigners
    module Type
      # Manages string assignments
      class String < Assigner
        include FakerHelper
        include MinMaxHelper
        include RegexHelper

        # Returns a random string matching validators
        # @return [String]
        # @note `regex_value` is generated in RegexHelper
        def value
          regex ? regex_value : default
        end

        private

        # Returns a standard string
        # @return [String]
        # @note `min` and `max` are defined in MinMaxHelper
        def default
          faker_value(
            generator: :Lorem,
            method: :paragraph_by_chars,
            options: { number: rand(min..max), supplemental: false }
          )
        end
      end
    end
  end
end
