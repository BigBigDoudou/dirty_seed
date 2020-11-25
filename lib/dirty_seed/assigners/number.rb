# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws an integer matching validators
    class Number < Assigner
      attr_reader :min, :max

      # Returns an value matching all validators
      # @return [Integer, Float]
      def value
        unless min && max
          define_min_and_max
          adjust_values
        end
        faker_value(
          category: :Number,
          method: :between,
          options: { from: min, to: max }
        )
      end

      private

      # Sets @min and @max if not already set
      # @return [void]
      def adjust_values
        return if @min && @max

        if @min
          @max = @min + random
        elsif @max
          @min = @max - random
        else
          @min = 0
          @max = random
        end
      end

      # Returns a random value
      # @return [Integer]
      def random
        rand(0..42)
      end

      # Defines @min and @max based on each validator
      # @return [void]
      def define_min_and_max
        validators.each do |validator|
          adjust_min!(validator)
          adjust_max!(validator)
        end
      end

      # Sets or updates @min so it matches validator
      # @param validator [ActiveModel::Validations::EachValidator]
      # @return [Integer, nil]
      def adjust_min!(validator)
        return unless min_for(validator)

        @min = min_for(validator) if @min.nil? || min_for(validator) > @min
      end

      # Sets or updates @max so it matches validator
      # @param validator [ActiveModel::Validations::EachValidator]
      # @return [Integer, nil]
      def adjust_max!(validator)
        return unless max_for(validator)

        @max = max_for(validator) if @max.nil? || max_for(validator) < @max
      end

      # Returns an value representing the minimal acceptable value
      # @param validator [ActiveModel::Validations::EachValidator]
      # @return [Integer]
      def min_for(validator)
        validator.options[:greater_than]&.+(gap) ||
          validator.options[:greater_than_or_equal_to] ||
          validator.options[:in]&.min
      end

      # Returns an value representing the maximal acceptable value
      # @param validator [ActiveModel::Validations::EachValidator]
      # @return [Integer]
      def max_for(validator)
        validator.options[:less_than]&.-(gap) ||
          validator.options[:less_than_or_equal_to] ||
          validator.options[:in]&.max
      end
    end
  end
end
