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
        return faker_value(specific) if specific

        default
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

      # Returns a value matching the requirements
      # @param category [Symbol] fake category
      # @param method [Symbol] fake method
      # @param unique [Boolean] should the value be unique
      # @param options [Hash] options used by faker
      # @return [String]
      def faker_value(category:, method:, unique: false, options: nil)
        action = "::Faker::#{category}".constantize
        action = action.unique if unique
        if options
          action.public_send(method, options)
        else
          action.public_send(method)
        end
      end

      # Returns a standard string
      # @return [String]
      def default
        ::Faker::Lorem.unique.sentence(word_count: 3, supplemental: false, random_words_to_add: 4)
      end
    end
  end
end
