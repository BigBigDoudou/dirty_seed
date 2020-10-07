# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws an integer matching validators
    class DirtyInteger < DirtyAssigner
      attr_reader :min, :max

      # returns an Integer matching all validators
      def value
        define_min_and_max
        adjust_values
        rand(min..max)
      end

      private

      # sets @min and @max if not already set
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

      # returns a random Integer
      def random
        rand(sequence..42)
      end

      # defines @min and @max based on each validator
      def define_min_and_max
        validators.each do |validator|
          adjust_min!(validator)
          adjust_max!(validator)
        end
      end

      # sets or updates @min so it matches validator
      # - validator: ActiveModel::Validations::EachValidator
      def adjust_min!(validator)
        return unless min_for(validator)

        @min = min_for(validator) if @min.nil? || min_for(validator) > @min
      end

      # sets or updates @max so it matches validator
      # - validator: ActiveModel::Validations::EachValidator
      def adjust_max!(validator)
        return unless max_for(validator)

        @max = max_for(validator) if @max.nil? || max_for(validator) < @max
      end

      # return an Integer representing the minimal acceptable value
      # - validator: ActiveModel::Validations::EachValidator
      def min_for(validator)
        validator.options[:greater_than]&.+(1) ||
          validator.options[:greater_than_or_equal_to] ||
          validator.options[:in]&.min
      end

      # return an Integer representing the maximal acceptable value
      # - validator: ActiveModel::Validations::EachValidator
      def max_for(validator)
        validator.options[:less_than]&.-(1) ||
          validator.options[:less_than_or_equal_to] ||
          validator.options[:in]&.max
      end
    end
  end
end
