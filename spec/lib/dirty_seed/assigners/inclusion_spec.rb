# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Inclusion do
  let(:attribute) { build_attribute(:integer) }
  let(:assigner) { described_class.new(attribute) }

  describe '#initialize' do
    it 'builds an instance' do
      expect(described_class.new(attribute)).to be_a described_class
    end
  end

  describe '#respond?' do
    context 'when attribute has an enum' do
      it 'returns true' do
        attribute.enum = %w[foo bar]
        expect(assigner.respond?).to be true
      end
    end

    context 'when attribute has an inclusion validation' do
      it 'returns true' do
        attribute.validators = [
          ActiveModel::Validations::InclusionValidator.new(attributes: :fake, in: [15, 30, 45])
        ]
        expect(assigner.respond?).to be true
      end
    end
  end

  describe '#value' do
    context 'when there is neither a validator nor an enum' do
      it 'returns nil' do
        10.times { expect(assigner.value).to be nil }
      end
    end

    context 'when there is an enum' do
      it 'returns one of the options' do
        attribute = build_attribute(:string)
        attribute.enum = %w[foo bar zed]
        assigner = described_class.new(attribute)
        10.times { expect(assigner.value).to be_in(%w[foo bar zed]) }
      end
    end

    context 'when there is an inclusion validator with an array' do
      it 'returns one of the options' do
        attribute = build_attribute(:string)
        attribute.validators = [
          ActiveModel::Validations::InclusionValidator.new(attributes: :fake, in: %w[foo bar zed])
        ]
        assigner = described_class.new(attribute)
        10.times { expect(assigner.value).to be_in(%w[foo bar zed]) }
      end
    end

    context 'when there is an inclusion validator with an range' do
      it 'returns a value included in the range' do
        assigner = described_class.new(attribute)
        attribute.validators = [
          ActiveModel::Validations::InclusionValidator.new(attributes: :fake, in: 0.0..1.0)
        ]
        10.times { expect(assigner.value).to be_between(0, 1) }
      end
    end
  end
end
