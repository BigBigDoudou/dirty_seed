# frozen_string_literal: true

require 'faker'

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class DirtyAssigner
      attr_reader :validators, :sequence

      # Initializes an instance
      # @param validators [Array<ActiveModel::Validation instances>]
      # @param sequence [Integer]
      # @return [DirtySeed::Assigners::DirtyAssigner]
      def initialize(validators: [], sequence: 0)
        self.validators = validators
        self.sequence = sequence
      end

      # Validates and sets @validators
      # @param value [Array<ActiveModel::Validator>]
      def validators=(value)
        raise ArgumentError unless value.is_a?(Array) && value.all? { |item| item.is_a? ActiveModel::Validator }

        @validators = value
      end

      # Validates and sets @sequence
      # @param value [Integer]
      def sequence=(value)
        raise ArgumentError unless value.is_a? Integer

        @sequence = value
      end

      # Returns a random value
      # @return [void]
      # @note This method should be overrided
      def value; end
    end
  end
end
