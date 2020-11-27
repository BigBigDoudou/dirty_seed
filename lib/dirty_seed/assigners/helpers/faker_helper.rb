# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Helps with faker values
    module FakerHelper
      MAX_RETRIES = 1_000
      private_constant :MAX_RETRIES

      # Returns a rabdom value matching the requirements
      # @param generator [Symbol] faker generator
      # @param method [Symbol] faker method
      # @param options [Hash] options used by faker
      # @return [Object]
      # @example
      #   faker_value(generator: :Internet, method: :email, options: { domain: 'example' })
      #     #=> "alice@example.name"
      # @note Faker raises a RetryLimitExceeded if it reaches MAX_RETRIES (with a unique generator)
      #   In this case return nil since it appears not to be possible to return a new unique value
      def faker_value(generator:, method:, options: nil)
        params = options ? [method, options] : [method]
        faker_generator(generator).public_send(*params)
      rescue Faker::UniqueGenerator::RetryLimitExceeded
        nil
      end

      private

      # Returns a faker generator
      # @param generator [Symbol] fake generator
      # @return [Class, Faker::UniqueGenerator] a faker class or a faker unique generator
      # @example
      #   Faker::Lorem
      #   Faker::UniqueGenerator.new(Faker::Lorem)
      def faker_generator(generator)
        @faker_generator ||=
          if unique?
            Faker::UniqueGenerator.new("::Faker::#{generator}".constantize, MAX_RETRIES)
          else
            "::Faker::#{generator}".constantize
          end
      end

      # Should the value be unique?
      # @return [Boolean]
      def unique?
        @unique ||=
          validators&.any? do |validator|
            validator.is_a? ActiveRecord::Validations::UniquenessValidator
          end
      end
    end
  end
end
