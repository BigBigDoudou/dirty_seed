# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws a value matching validators
    class DirtyAssigner
      attr_reader :validators, :sequence

      # initializes an instance with:
      # - validators: Array of ActiveModel::Validation instances
      # - sequence: Integer
      def initialize(validators: [], sequence: 0)
        self.validators = validators
        self.sequence = sequence
      end

      # validates and sets @validators
      def validators=(value)
        raise ArgumentError unless value.is_a?(Array) && value.all? { |item| item.is_a? ActiveModel::Validator }

        @validators = value
      end

      # validates and sets @sequence
      def sequence=(value)
        raise ArgumentError unless value.is_a? Integer

        @sequence = value
      end

      # returns a random value
      def value; end
    end
  end
end
