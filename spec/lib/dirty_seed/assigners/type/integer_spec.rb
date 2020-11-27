# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Type::Integer do
  let(:attribute) { build_attribute(:integer) }
  let(:assigner) { described_class.new(attribute) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns an integer' do
        10.times { expect(assigner.value).to be_an Integer }
      end
    end

    context 'when there is greater_than validator' do
      it 'returns an integer greater than the requirement' do
        attribute.validators = [
          ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 1_000)
        ]
        10.times { expect(assigner.value).to be >= 1_000 }
      end
    end

    context 'when there is less_than validator' do
      it 'returns an integer less than the requirement' do
        attribute.validators = [
          ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, less_than: -1_000)
        ]
        10.times { expect(assigner.value).to be < -1_000 }
      end
    end

    context 'when there are less_than and greater_than validators' do
      it 'returns an integer greater than and less than the requirements' do
        attribute.validators = [
          ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 1, less_than: 5)
        ]
        10.times { expect(assigner.value).to be_between(1, 5).exclusive }
      end
    end
  end
end
