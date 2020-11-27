# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Manages assignment when value should be included in an enumerable
    class Inclusion < Assigner
      # Returns a random value matching validators
      # @return [Object] a "primitive"
      def value
        return unless respond?

        case options
        when Array then options.sample
        when Range then rand(options)
        end
      end

      # Should be the value included in options?
      # @return [Boolean]
      def respond?
        @respond ||= options.present?
      end

      private

      # Returns the inclusion options if value should be included in options
      # @return [Array, Range]
      # @example
      #   ["todo", "done", "aborted"]
      #   0..10
      def options
        @options ||= enum || inclusion_validator&.options&.dig(:in)
      end

      # Returns the inclusion validator if any
      #   e.g. `validates :status, inclusion: { in: ["todo", "done", "aborted"] }`
      # @return [ActiveModel::Validations::InclusionValidator, nil]
      def inclusion_validator
        validators&.find do |validator|
          validator.is_a? ActiveModel::Validations::InclusionValidator
        end
      end
    end
  end
end
