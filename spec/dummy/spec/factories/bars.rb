# frozen_string_literal: true

FactoryBot.define do
  factory :bar do
    sequence(:name) { |n| "bar_#{n}" }
    foo
  end
end
