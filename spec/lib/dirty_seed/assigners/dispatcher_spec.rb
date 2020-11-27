# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Dispatcher do
  let(:attribute) { build_attribute(:integer) }
  let(:assigner) { described_class.new(attribute) }

  describe '#initialize' do
    it 'builds an instance' do
      expect(described_class.new(attribute)).to be_a described_class
    end
  end

  describe '#value' do
    context 'when value should be absent' do
      it 'returns nil' do
        validator = ActiveRecord::Validations::AbsenceValidator.new(attributes: :fake)
        allow(assigner).to receive(:validators).and_return([validator])
        10.times { expect(assigner.value).to be_nil }
      end
    end

    context 'when the value should be included in given options' do
      it 'returns one of the options' do
        attribute.enum = %w[foo bar zed]
        assigner = described_class.new(attribute)
        10.times { expect(assigner.value).to be_in(%w[foo bar zed]) }
      end
    end

    context 'when the attribute is meaningful' do
      it 'returns a meaningful value' do
        attribute = build_attribute(:string, :email)
        assigner = described_class.new(attribute)
        10.times { expect(assigner.value).to match(URI::MailTo::EMAIL_REGEXP) }
      end
    end

    context 'when the attribute is an array' do
      it 'returns an array of values' do
        attribute = build_attribute(:'integer[]')
        assigner = described_class.new(attribute)
        10.times { expect(assigner.value).to be_an Array }
      end
    end

    context 'when there is no assigner for the attribute type' do
      it 'returns nil' do
        attribute = build_attribute(:thing, :a_thing)
        assigner = described_class.new(attribute)
        10.times { expect(assigner.value).to be_nil }
      end
    end
  end
end
