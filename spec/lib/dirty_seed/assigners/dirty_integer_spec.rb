# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyInteger do
  let(:dirty_attribute) { build_dirty_attribute(type: :integer) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns an integer' do
        expect(described_class.new(dirty_attribute, 0).value).to be_an Integer
      end
    end

    context 'when there is greater_than validator' do
      it 'returns an integer greater than the requirement' do
        assigner = described_class.new(dirty_attribute, 0)
        validator = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 1_000)
        allow(assigner.dirty_attribute).to receive(:validators).and_return([validator])
        5.times { expect(assigner.value).to be >= 1_000 }
      end
    end

    context 'when there is less_than validator' do
      it 'returns an integer less than the requirement' do
        assigner = described_class.new(dirty_attribute, 0)
        validator = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, less_than: -1_000)
        allow(assigner.dirty_attribute).to receive(:validators).and_return([validator])
        5.times { expect(assigner.value).to be < -1_000 }
      end
    end

    context 'when there are less_than and greater_than validators' do
      it 'returns an integer greater than and less than the requirements' do
        greater_than = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, greater_than: 1)
        less_than = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, less_than: 5)
        assigner = described_class.new(dirty_attribute, 0)
        allow(assigner.dirty_attribute).to receive(:validators).and_return([greater_than, less_than])
        5.times do
          value = assigner.value
          expect(value).to be > 1
          expect(value).to be < 5
        end
      end
    end
  end
end
