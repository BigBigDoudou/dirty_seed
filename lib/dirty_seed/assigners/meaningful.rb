# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Manages attributes that are meaningful
    class Meaningful < Assigner
      include FakerHelper

      # Returns a random meaningful value
      # @return [Object] a "primitive"
      def value
        return unless respond?

        faker_value(meaningful_options.except(:types))
      end

      # Can meaning be guessed and does faker type match attribute type?
      # @return [Boolean]
      # @note For instance, if there is a faker match but faker return a string
      #   And the attribute type is float then return false
      def respond?
        @respond ||= meaningful_options.present? && meaningful_options[:types].include?(type.to_s)
      end

      private

      # Returns the meaningful options if the attribute name is meaningful
      # @return [Hash, nil]
      def meaningful_options
        @meaningful_options ||= meaningful_attributes[name]
      end

      # Returns meaningful attributes
      # @return [Hash]
      # @example
      #   { address: { generator: 'Address', method: 'full_address' } }
      def meaningful_attributes
        ::YAML.safe_load(
          ::File.read(
            DirtySeed::Engine.root.join(
              'lib', 'config', 'meaningful_attributes.yml'
            )
          )
        ).deep_symbolize_keys
      end
    end
  end
end
