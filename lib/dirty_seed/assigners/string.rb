# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a String matching validators
    class String < Assigner
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
          method: :sentence,
          options: { word_count: 3, supplemental: false, random_words_to_add: 4 }
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
