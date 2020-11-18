# frozen_string_literal: true

module DirtySeed
  module Assigners
    # Draws a String matching validators
    class DirtyString < DirtyAssigner
      SPECIFIC_ATTRIBUTES = {
        address: -> { Faker::Address.unique.full_address },
        city: -> { Faker::Address.unique.city },
        country: -> { Faker::Address.unique.country },
        description: -> { Faker::Lorem.unique.paragraph(sentence_count: 2, random_sentences_to_add: 4) },
        email: -> { Faker::Internet.unique.email(domain: 'example') },
        first_name: -> { ::Faker::Name.unique.first_name },
        firstname: -> { ::Faker::Name.unique.first_name },
        last_name: -> { ::Faker::Name.unique.last_name },
        lastname: -> { ::Faker::Name.unique.last_name },
        lat: -> { Faker::Address.unique.latitude },
        latitutde: -> { Faker::Address.unique.latitude },
        lng: -> { Faker::Address.unique.longitude },
        locale: -> { Faker::Address.unique.country_code },
        longitude: -> { Faker::Address.unique.longitude },
        middlename: -> { ::Faker::Name.unique.middle_name },
        middle_name: -> { ::Faker::Name.unique.middle_name },
        password: -> { ::Faker::Internet.unique.password },
        phone: -> { Faker::PhoneNumber.unique.phone_number },
        phone_number: -> { Faker::PhoneNumber.unique.phone_number },
        reference: -> { Faker::Internet.unique.uuid },
        title: -> { Faker::Lorem.unique.sentence(word_count: 3, random_words_to_add: 4) },
        username: -> { Faker::Internet.unique.username }
      }.freeze
      private_constant :SPECIFIC_ATTRIBUTES

      # Returns a string matching all validators
      # @return [String]
      def value
        SPECIFIC_ATTRIBUTES[dirty_attribute.name]&.call ||
          ::Faker::Lorem.unique.sentence(word_count: 3, supplemental: false, random_words_to_add: 4)
      end
    end
  end
end
