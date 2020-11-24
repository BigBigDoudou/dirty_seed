# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a String matching validators
    class DirtyString < DirtyAssigner
      # Returns a value matching all validators
      # @return [String]
      # @note First try to guess attribute meaning by its name and use Faker to return a coherent value
      def value
        specific = specific_attributes[dirty_attribute.name]
        specific && faker_value(specific) || default
      end

      private

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
    end
  end
end
