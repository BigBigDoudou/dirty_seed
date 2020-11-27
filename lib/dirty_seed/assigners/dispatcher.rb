# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Dispatchs to the adapted assigner
    class Dispatcher < SimpleDelegator
      # @!method initialize(attribute)
      # @param attribute [DirtySeed::Attribute]
      # @return [DirtySeed::Assigners::Dispatcher]

      TYPE_ASSIGNERS = %i[boolean date float integer json string time].freeze
      private_constant :TYPE_ASSIGNERS

      # Returns a value depending on type and validators
      # @return [Object] a "primitive"
      def value
        return if absence_validator? || !assigner

        array? ? Array.new(3) { assigner.value } : assigner.value
      end

      private

      # Returns true if value should be absent
      # Returns [Boolean]
      def absence_validator?
        validators&.any? do |validator|
          validator.is_a? ActiveRecord::Validations::AbsenceValidator
        end
      end

      # Returns an adapted assigner depending on type and validators
      # @return [#value]
      def assigner
        return inclusion_assigner if inclusion_assigner.respond?
        return meaningful_assigner if meaningful_assigner.respond?

        type_assigner
      end

      # Returns an assigner managing inclusion validators
      # @return [DirtySeed::Assigners::Inclusion]
      def inclusion_assigner
        @inclusion_assigner ||= DirtySeed::Assigners::Inclusion.new(__getobj__)
      end

      # Returns an assigner managing meaningful attributes
      # @return [DirtySeed::Assigners::Meaningful]
      def meaningful_assigner
        @meaningful_assigner ||= DirtySeed::Assigners::Meaningful.new(__getobj__)
      end

      # Returns an assigner dedicated to the attribute type
      # @return [#value]
      # @note If attribute type is not currently handled (json, array...), return nil
      def type_assigner
        @type_assigner ||=
          type.in?(TYPE_ASSIGNERS) &&
          "DirtySeed::Assigners::Type::#{type.to_s.capitalize}".constantize.new(__getobj__)
      end
    end
  end
end
