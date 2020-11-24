# frozen_string_literal: true

require 'faker'

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class DirtyAssigner
      attr_reader :dirty_attribute, :sequence

      # Initializes an instance
      # @param attribute [DirtySeed::DirtyAttribute]
      # @param sequence [Integer]
      # @return [DirtySeed::Assigners::DirtyAssigner]
      def initialize(dirty_attribute, sequence)
        @dirty_attribute = dirty_attribute
        @sequence = sequence
      end

      # Returns an validators related to the current attribute
      # @return [Array<ActiveModel::Validations::EachValidators>]
      def validators
        dirty_attribute.validators
      end

      # Returns a random value depending on the attribute type
      # @return [void]
      # @note This method should be overrided
      def value; end

      # Returns true if the value should be unique
      # @return [Boolean]
      def unique?
        validators.any? { |validator| validator.options[:uniqueness] }
      end

      # Returns a value matching the requirements
      # @param category [Symbol] fake category
      # @param method [Symbol] fake method
      # @param unique [Boolean] should the value be unique
      # @param options [Hash] options used by faker
      # @return [Object]
      def faker_value(category:, method:, options: nil)
        action = "::Faker::#{category}".constantize
        action = action.unique if unique?
        options ? action.public_send(method, options) : action.public_send(method)
      end
    end
  end
end
