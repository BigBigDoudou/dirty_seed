# frozen_string_literal: true

require 'regexp-examples'

module DirtySeed
  module Assigners
    # Draws a value matching validators
    class Assigner
      attr_reader :attribute

      delegate :name, :type, :validators, to: :attribute

      # Initializes an instance
      # @param attribute [DirtySeed::Attribute]
      # @return [DirtySeed::Assigners::Assigner]
      def initialize(attribute)
        @attribute = attribute
      end

      private

      # Returns true if the value should be unique
      # @return [Boolean]
      def unique?
        @unique ||=
          validators.any? do |validator|
            validator.is_a? ActiveRecord::Validations::UniquenessValidator
          end
      end

      # Returns the regex pattern if value should respect a format
      # e.g. `validates :email, format: { with: /\w{10}@(hotmail|gmail)\.com/ }`
      # @return [Array<>]
      def regex
        regex_validator =
          validators.find do |validator|
            validator.is_a? ActiveModel::Validations::FormatValidator
          end
        regex_validator&.options&.dig(:with)
      end

      # Returns a value matching the requirements
      # @param category [Symbol] fake category
      # @param method [Symbol] fake method
      # @param options [Hash] options used by faker
      # @return [Object]
      def faker_value(category:, method:, options: nil)
        if options
          faker_method(category).public_send(method, options)
        else
          faker_method(category).public_send(method)
        end
      rescue Faker::UniqueGenerator::RetryLimitExceeded
        nil
      end

      # Returns a faker method
      # @param category [Symbol] fake category
      # @return [Faker::?]
      def faker_method(category)
        @faker_method ||= define_faker_method(category)
      end

      # Returns a faker method
      # @param category [Symbol] fake category
      # @return [Faker::?]
      def define_faker_method(category)
        action = "::Faker::#{category}".constantize
        unique? ? action.unique : action
      end
    end
  end
end
