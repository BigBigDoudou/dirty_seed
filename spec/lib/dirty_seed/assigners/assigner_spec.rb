# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Assigner do
  describe 'uniqueness' do
    context 'when value should be unique' do
      it 'returns unique value or nil' do
        attribute = build_attribute(:integer)
        assigner = DirtySeed::Assigners::Type::Integer.new(attribute)
        range = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, in: 1..2)
        uniqueness = ActiveRecord::Validations::UniquenessValidator.new(attributes: :fake)
        allow(assigner).to receive(:validators).and_return([range, uniqueness])
        values = Array.new(4) { assigner.value }
        expect(values).to match_array([1, 2, nil, nil])
      end
    end
  end
end
