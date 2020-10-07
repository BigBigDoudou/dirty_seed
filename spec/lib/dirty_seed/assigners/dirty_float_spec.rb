# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyFloat do
  describe '#value' do
    context 'when there are no validators' do
      it 'returns an integer' do
        expect(described_class.new.value).to be_a Float
      end
    end

    context 'when there is greater_than validator' do
      it 'returns an integer greater than the requirement' do
        validator = ActiveModel::Validations::NumericalityValidator.new(
          attributes: :fake, greater_than: 1_000
        )
        assigner = described_class.new(validators: [validator])
        10.times { expect(assigner.value).to be >= 1_000 }
      end
    end

    context 'when there is less_than validator' do
      it 'returns an integer less than the requirement' do
        validator = ActiveModel::Validations::NumericalityValidator.new(
          attributes: :fake, less_than: -1_000
        )
        assigner = described_class.new(validators: [validator])
        10.times { expect(assigner.value).to be < -1_000 }
      end
    end

    context 'when there are less_than and greater_than validators' do
      it 'returns an integer greater than and less than the requirements' do
        greater_than = ActiveModel::Validations::NumericalityValidator.new(
          attributes: :fake, greater_than: 1
        )
        less_than = ActiveModel::Validations::NumericalityValidator.new(
          attributes: :fake, less_than: 5
        )
        # greater_than = set_validator(type: :greater_than, value: 1)
        # less_than = set_validator(type: :less_than, value: 5)
        assigner = described_class.new(validators: [greater_than, less_than])
        10.times do
          value = assigner.value
          expect(value).to be > 1
          expect(value).to be < 5
        end
      end
    end
  end
end
