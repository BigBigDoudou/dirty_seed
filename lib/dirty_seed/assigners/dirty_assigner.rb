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
    end
  end
end
