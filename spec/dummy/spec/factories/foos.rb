# frozen_string_literal: true

FactoryBot.define do
  factory :foo do
    sequence(:name) { |n| "foo_#{n}" }
  end
end
