# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::String do
  let(:data_model) { DirtySeed::DataModel }
  let(:attribute) { build_attribute(type: :string) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a String' do
        expect(described_class.new(attribute).value).to be_a String
      end
    end

    context 'when value should match pattern' do
      it 'returns a value matching the pattern' do
        attribute = build_attribute(type: :string)
        assigner = described_class.new(attribute)
        regex = /\w{10}@(hotmail|gmail)\.com/
        validator = ActiveModel::Validations::FormatValidator.new(attributes: :fake, with: regex)
        allow(assigner.attribute).to receive(:validators).and_return([validator])
        10.times { expect(assigner.value).to match(regex) }
      end
    end

    context 'when the length has a minimim validation' do
      it 'returns a value with the required length' do
        attribute = build_attribute(type: :string)
        assigner = described_class.new(attribute)
        validator = ActiveRecord::Validations::LengthValidator.new(attributes: :fake, minimum: 5)
        allow(assigner.attribute).to receive(:validators).and_return([validator])
        10.times { expect(assigner.value.length).to be >= 5 }
      end
    end

    context 'when the length has a maximum validation' do
      it 'returns a value with the required length' do
        attribute = build_attribute(type: :string)
        assigner = described_class.new(attribute)
        validator = ActiveRecord::Validations::LengthValidator.new(attributes: :fake, maximum: 5)
        allow(assigner.attribute).to receive(:validators).and_return([validator])
        10.times { expect(assigner.value.length).to be <= 5 }
      end
    end
  end
end
