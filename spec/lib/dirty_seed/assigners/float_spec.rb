# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Float do
  let(:attribute) { build_attribute(type: :float) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a float' do
        10.times { expect(described_class.new(attribute).value).to be_a Float }
      end
    end

    context 'when there is greater_than validator' do
      it 'returns a float greater than the requirement' do
        assigner = described_class.new(attribute)
        validator = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 1_000)
        allow(attribute).to receive(:validators).and_return([validator])
        10.times { expect(assigner.value).to be >= 1_000 }
      end
    end

    context 'when there is less_than validator' do
      it 'returns a float less than the requirement' do
        assigner = described_class.new(attribute)
        validator = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, less_than: -1_000)
        allow(attribute).to receive(:validators).and_return([validator])
        10.times { expect(assigner.value).to be < -1_000 }
      end
    end

    context 'when there is greater_and less_than validators' do
      it 'returns a float greater than and less than the requirements' do
        assigner = described_class.new(attribute)
        validator =
          ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 0, less_than: 1)
        allow(attribute).to receive(:validators).and_return([validator])
        10.times { expect(assigner.value).to be_between(0, 1).exclusive }
      end
    end
  end
end
