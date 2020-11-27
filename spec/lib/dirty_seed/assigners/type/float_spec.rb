# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Type::Float do
  let(:attribute) { build_attribute(:float) }
  let(:assigner) { described_class.new(attribute) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a float' do
        10.times { expect(assigner.value).to be_a Float }
      end
    end

    context 'when there is greater_than validator' do
      it 'returns a float greater than the requirement' do
        attribute.validators = [
          ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 1_000)
        ]
        10.times { expect(assigner.value).to be >= 1_000 }
      end
    end

    context 'when there is less_than validator' do
      it 'returns a float less than the requirement' do
        attribute.validators = [
          ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, less_than: -1_000)
        ]
        10.times { expect(assigner.value).to be < -1_000 }
      end
    end

    context 'when there is greater_and less_than validators' do
      it 'returns a float greater than and less than the requirements' do
        attribute.validators = [
          ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 0, less_than: 1)
        ]
        10.times { expect(assigner.value).to be_between(0, 1).exclusive }
      end
    end
  end
end
