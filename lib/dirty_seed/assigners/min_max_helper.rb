# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Helps with min and max validations
    module MinMaxHelper
      # Returns the minimal value
      # @return [Integer, Float]
      def min
        @min ||= define_min_and_max && @min
      end

      # Returns the maximal value
      # @return [Integer, Float]
      def max
        @max ||= define_min_and_max && @max
      end

      # Defines min and max depending on validator
      # @return [void]
      def define_min_and_max
        @min = acceptable_min
        @max = acceptable_max

        # If necessary, adjust a value depending on the other
        @min ||= floor
        @max ||= @min + ceiling || ceiling # rubocop:disable Naming/MemoizedInstanceVariableName
      end

      # Returns default min depending on type
      # @return [Integer, Float]
      def floor # rubocop:disable Metrics/CyclomaticComplexity
        case type
        when :string then 1
        when :integer then @max&.negative? ? @max * 2 : 0
        when :float then @max&.negative? ? @max * 2 : 0.0
        end
      end

      # Returns default max depending on type
      # @return [Integer, Float]
      def ceiling
        case type
        when :string then 50
        when :integer then 42
        when :float then 42.0
        end
      end

      # Returns the validator that validate min and/or max
      def min_max_validator
        validators.find { |validator| validator.is_a? validator_class }
      end

      # Returns the validator class depending on the type
      def validator_class
        case type
        when :string then ActiveRecord::Validations::LengthValidator
        when :integer, :float then ActiveModel::Validations::NumericalityValidator
        end
      end

      # Returns a value representing the minimal acceptable value
      # @return [Integer, Float]
      def acceptable_min
        return unless min_max_validator

        min_max_validator.options[:in]&.min || type_related_acceptable_min
      end

      # Returns a value representing the minimal acceptable value depending on type
      # @return [Integer, Float]
      def type_related_acceptable_min
        case type
        when :string
          min_max_validator.options[:minimum] || min_max_validator.options[:is]
        when :integer, :float
          min_max_validator.options[:greater_than]&.+(gap) ||
            min_max_validator.options[:greater_than_or_equal_to]
        end
      end

      # Returns a value representing the maximal acceptable value
      # @return [Integer, Float]
      def acceptable_max
        return unless min_max_validator

        min_max_validator.options[:in]&.max || type_related_acceptable_max
      end

      # Returns a value representing the maximal acceptable value depending on type
      # @return [Integer, Float]
      def type_related_acceptable_max
        case type
        when :string
          min_max_validator.options[:maximum] || min_max_validator.options[:is]
        when :integer, :float
          min_max_validator.options[:less_than]&.-(gap) ||
            min_max_validator.options[:less_than_or_equal_to]
        end
      end

      # Defines the gap to add to min when "greater_than" or to substract to max when "less_than"
      #   For example if type is :float and value should be greater_than 0, then the min is 0.01
      #     and if the value should be lesser_than 1, then the max is 0.99
      # @return [Integer, Float]
      def gap
        case type
        when :integer then 1
        when :float then 0.01
        end
      end
    end
  end
end
