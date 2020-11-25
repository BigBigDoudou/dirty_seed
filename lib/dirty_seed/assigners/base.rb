# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class Base < Assigner
      SPECIFIC_TYPES = %i[float integer string].freeze
      private_constant :SPECIFIC_TYPES

      # Returns a value depending on validators and attribute type
      #   It firstly check if value can be set relying to validators
      #   If not, it delegates to an assigner adapted to the attribute type
      # @return [<?>] depends on attribute
      def value
        return if absent?
        return inclusion_options.sample if inclusion_options

        try_specific || adapted_assigner&.value
      end

      private

      # Returns true if value should be absent
      # Returns [Boolean]
      def absent?
        validators.any? do |validator|
          validator.is_a? ActiveRecord::Validations::AbsenceValidator
        end
      end

      # Returns the inclusion options if value should be included in options
      # e.g. `validates :status, inclusion: { in: %w[todo done aborted] }`
      # @return [Array<>]
      def inclusion_options
        inclusion_validator =
          validators.find do |validator|
            validator.is_a? ActiveModel::Validations::InclusionValidator
          end
        inclusion_validator&.options&.dig(:in)
      end

      # If attribute name is listed in meaningful attributes
      #   Then rely on faker
      #   And validate it matches type and other validations
      # @return [<?>] depends on attribute
      def try_specific
        return unless specific_options
        return unless specific_options[:types].include? type.to_s

        try = faker_value(specific_options.except(:types))
        return if regex && !regex.match?(try)

        try
      end

      # Returns the specific options if the attribute name is specific
      # @return [Hash, nil]
      def specific_options
        @specific_options ||= specific_attributes[name]
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

      # Returns the adapted assigner depending on type
      # @return [DirtySeed::Assigners::<?>]
      def adapted_assigner
        @adapted_assigner ||=
          "DirtySeed::Assigners::#{attribute.type.capitalize}".constantize.new(attribute)
        # If attribute type is not currently handled (json, array...) return nil
      rescue NameError
        nil
      end
    end
  end
end
