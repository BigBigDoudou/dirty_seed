# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws a value matching validators
    class DirtyAssigner
      attr_reader :validators, :sequence

      # initializes an instance with:
      # - validators: Array of ActiveModel::Validation instances
      def initialize(validators: [], sequence: 0)
        @validators = validators
        @sequence = sequence
        validate_arguments!
      end

      # returns a random value
      def value; end

      private

      # validates that arguments match expected types
      def validate_arguments!
        validators.is_a?(Array) && validators.all? { |validator| validator.is_a?(ActiveModel::Validator) } ||
          raise(ArgumentError, 'each :validators should be an ActiveModel::Validation instances')

        sequence.is_a?(Integer) ||
          raise(ArgumentError, ':sequence should be an Integer')
      end
    end
  end
end
