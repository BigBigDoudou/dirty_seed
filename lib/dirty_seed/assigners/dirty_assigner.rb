# frozen_string_literal: true

require 'faker'

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class DirtyAssigner
      attr_reader :dirty_attribute

      # Initializes an instance
      # @param attribute [DirtySeed::DirtyAttribute]
      # @return [DirtySeed::Assigners::DirtyAssigner]
      def initialize(dirty_attribute)
        @dirty_attribute = dirty_attribute
      end

      # Returns an validators related to the current attribute
      # @return [Array<ActiveModel::Validations::EachValidators>]
      def validators
        dirty_attribute.validators || []
      end

      # Returns the current sequence
      # @return [Integer]
      def sequence
        dirty_attribute.sequence || 0
      end

      # Returns a random value depending on the attribute type
      # @return [void]
      # @note This method should be overrided
      def value; end
    end
  end
end
