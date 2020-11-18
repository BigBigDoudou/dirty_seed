# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a String matching validators
    class DirtyString < DirtyAssigner
      SPECIFIC_ATTRIBUTES = {
        email: Faker::Internet.email(domain: 'example'),
        firstname: ::Faker::Name.first_name,
        first_name: ::Faker::Name.first_name,
        lastname: ::Faker::Name.last_name,
        middlename: ::Faker::Name.middle_name,
        middle_name: ::Faker::Name.middle_name,
        name: ::Faker::Name.name,
        last_name: ::Faker::Name.last_name,
      }.freeze
      private_constant :SPECIFIC_ATTRIBUTES

      # Returns a string matching all validators
      # @return [String]
      def value
        SPECIFIC_ATTRIBUTES[dirty_attribute&.name] ||
          ::Faker::Lorem.sentence(word_count: 3 + sequence % 2)
      end
    end
  end
end
