# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a String matching validators
    class String < Assigner
      include MinMaxHelper

      # Returns a value matching all validators
      # @return [String]
      def value
        regex_value || default
      end

      private

      # Returns a standard string
      # @return [String]
      def default
        faker_value(
          category: :Lorem,
          method: :paragraph_by_chars,
          options: { number: rand(min..max), supplemental: false }
        )
      end

      # Returns a value matching the pattern
      # @note Rescue from unreadable regex
      # @return [String]
      def regex_value
        return unless regex

        regex.random_example
      rescue RegexpExamples::IllegalSyntaxError
        nil
      end
    end
  end
end
