# frozen_string_literal: true

require 'regexp-examples'

module DirtySeed
  module Assigners
    # Helps with regex validations
    module RegexHelper
      # Returns the regex pattern if value should respect a format
      #   For example when: `validates :email, format: { with: /\w{10}@(hotmail|gmail)\.com/ }`
      # @return [Regex]
      def regex
        regex_validator =
          validators&.find do |validator|
            validator.is_a? ActiveModel::Validations::FormatValidator
          end
        regex_validator&.options&.dig(:with)
      end

      # Returns a random value matching the pattern
      # @return [String]
      # @note Rescue from unreadable regex with nil
      def regex_value
        regex.random_example
      rescue RegexpExamples::IllegalSyntaxError
        nil
      end
    end
  end
end
