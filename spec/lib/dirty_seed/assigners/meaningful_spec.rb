# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Meaningful do
  describe '#initialize' do
    it 'builds an instance' do
      attribute = build_attribute(:string)
      expect(described_class.new(attribute)).to be_a described_class
    end
  end

  describe '#respond?' do
    context 'when the attribute name is meaningful' do
      context 'when attribute type is in the meaningful types' do
        it 'returns true' do
          attribute = build_attribute(:string, :email)
          assigner = described_class.new(attribute)
          expect(assigner.respond?).to be true
        end
      end

      context 'when attribute type is not in the meaningful types' do
        it 'returns false' do
          attribute = build_attribute(:integer, :email)
          assigner = described_class.new(attribute)
          expect(assigner.respond?).to be false
        end
      end
    end
  end

  describe '#value' do
    context 'when attribute type matches accepted types' do
      it 'returns a meaningful value (example: string "email")' do
        attribute = build_attribute(:string, :email)
        assigner = described_class.new(attribute)
        10.times { expect(assigner.value).to match(URI::MailTo::EMAIL_REGEXP) }
      end

      it 'returns a meaningful value (example: float "latitude")' do
        attribute = build_attribute(:float, :latitude)
        assigner = described_class.new(attribute)
        10.times do
          expect(assigner.value).to be_a Float
          expect(assigner.value.to_s).to match(/-?\d+\.\d{9,}/)
        end
      end
    end
  end
end
