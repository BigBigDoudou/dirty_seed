# frozen_string_literal: true

require 'faker'
require 'regexp-examples'

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

      # Returns a random value depending on the attribute type
      # @return [void]
      # @note This method should be overrided
      def value
        return if absent?
        return inclusion_options.sample if inclusion_options

        define_value
      end

      private

      # Returns an validators related to the current attribute
      # @return [Array<ActiveModel::Validations::EachValidators>]
      def validators
        @validators ||= dirty_attribute.validators
      end

      # Returns nil, should be overrided by inherited classes
      # @return [nil]
      def define_value; end

      # Returns true if value should be absent
      # Returns [Boolean]
      def absent?
        validators.any? do |validator|
          validator.is_a? ActiveRecord::Validations::AbsenceValidator
        end
      end

      # Returns the inclusion options if value should be included in options
      # e.g. `validates :status, inclusion: { in: %w[todo done aborted] }`
      # @return [Array<>]
      def inclusion_options
        inclusion_validator =
          validators.find do |validator|
            validator.is_a? ActiveModel::Validations::InclusionValidator
          end
        inclusion_validator&.options&.dig(:in)
      end

      # Returns true if the value should be unique
      # @return [Boolean]
      def unique?
        @unique ||=
          validators.any? do |validator|
            validator.is_a? ActiveRecord::Validations::UniquenessValidator
          end
      end

      # Returns a value matching the requirements
      # @param category [Symbol] fake category
      # @param method [Symbol] fake method
      # @param options [Hash] options used by faker
      # @return [Object]
      def faker_value(category:, method:, options: nil)
        if options
          faker_process(category).public_send(method, options)
        else
          faker_process(category).public_send(method)
        end
      rescue Faker::UniqueGenerator::RetryLimitExceeded
        nil
      end

      # Returns a faker process
      # @param category [Symbol] fake category
      # @return [Faker::?]
      def faker_process(category)
        return @faker_method if @faker_method

        action = "::Faker::#{category}".constantize
        @faker_method = unique? ? action.unique : action
      end
    end
  end
end
