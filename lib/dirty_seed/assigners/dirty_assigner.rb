# frozen_string_literal: true

require 'faker'

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class DirtyAssigner
      attr_reader :attribute

      # Initializes an instance
      # @param attribute [DirtySeed::DirtyAttribute]
      # @return [DirtySeed::Assigners::DirtyAssigner]
      def initialize(attribute: nil)
        self.attribute = attribute
      end

      # Validates and sets @attribute
      # @param value [DirtySeed::DirtyAttribute]
      # @return [DirtySeed::DirtyAttribute]
      # @raise [ArgumentError] if value is not valid
      def attribute=(value)
        raise ArgumentError unless value.nil? || value.is_a?(DirtySeed::DirtyAttribute)

        @attribute = value
      end

      # Returns an validators related to the current attribute
      # @return [Array<ActiveModel::Validations::EachValidators>]
      def validators
        attribute&.validators || []
      end

      # Returns the current sequence
      # @return [Integer]
      def sequence
        attribute&.sequence || 0
      end

      # Returns a random value
      # @return [void]
      # @note This method should be overrided
      def value; end
    end
  end
end
