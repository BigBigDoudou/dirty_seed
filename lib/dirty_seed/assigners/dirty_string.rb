# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a String matching validators
    class DirtyString < DirtyAssigner
      # Returns a value matching all validators
      # @return [String]
      # @note First try to guess attribute meaning by its name and use Faker to return a coherent value
      #   Then eventually return a value matching the regex validation
      def define_value
        specific_value || regex_value || default
      end

      private

      # Returns a specific value if the attribute name is specific
      # @note Verify that, if there is a regex validation, the value matches it
      # @return [String]
      def specific_value
        return unless specific

        try = faker_value(specific)
        try if !regex || regex.match?(try)
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

      # Returns the specific options if the attribute name is specific
      # @return [Hash, nil]
      def specific
        @specific ||= specific_attributes[dirty_attribute.name]
      end

      # Returns specific attributes
      # @return [Hash]
      # @example
      #   { address: { category: 'Address', method: 'full_address' } }
      def specific_attributes
        YAML.safe_load(
          File.read(
            DirtySeed::Engine.root.join('lib', 'dirty_seed', 'assigners', 'fakers.yml')
          )
        ).deep_symbolize_keys
      end

      # Returns a standard string
      # @return [String]
      def default
        ::Faker::Lorem.unique.sentence(word_count: 3, supplemental: false, random_words_to_add: 4)
      end

      # Returns the regex pattern if value should respect a format
      # e.g. `validates :email, format: { with: /\w{10}@(hotmail|gmail)\.com/ }`
      # @return [Array<>]
      def regex
        regex_validator =
          validators.find do |validator|
            validator.is_a? ActiveModel::Validations::FormatValidator
          end
        regex_validator&.options&.dig(:with)
      end
    end
  end
end
