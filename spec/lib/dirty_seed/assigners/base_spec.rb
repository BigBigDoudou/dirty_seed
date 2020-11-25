# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Base do
  let(:attribute) { build_attribute(type: :integer) }
  let(:assigner) { described_class.new(attribute) }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(described_class.new(attribute)).to be_a described_class
    end
  end

  describe '#value' do
    context 'when value should be absent (absence: true)' do
      it 'returns nil' do
        validator = ActiveRecord::Validations::AbsenceValidator.new(attributes: :fake)
        allow(assigner.attribute).to receive(:validators).and_return([validator])
        expect(assigner.value).to be_nil
      end
    end

    context 'when value should be one of given options (inclusion: { in: %w[foo bar zed] })' do
      context 'when type is a string' do
        it 'returns one of the options' do
          attribute = build_attribute(type: :string)
          validator = ActiveModel::Validations::InclusionValidator.new(attributes: :fake, in: %w[foo bar zed])
          allow(attribute).to receive(:validators).and_return([validator])
          assigner = described_class.new(attribute)
          expect(assigner.value).to be_in(%w[foo bar zed])
        end
      end

      context 'when type is an integer' do
        it 'returns one of the options' do
          attribute = build_attribute(type: :integer)
          validator = ActiveModel::Validations::InclusionValidator.new(attributes: :fake, in: [15, 30, 45])
          allow(attribute).to receive(:validators).and_return([validator])
          assigner = described_class.new(attribute)
          expect(assigner.value).to be_in([15, 30, 45])
        end
      end
    end

    context 'when attribute name is listed in meaningful attributes' do
      context 'when attribute type matches accepted types' do
        it 'returns a meaningful value (example: string "email")' do
          attribute = build_attribute(name: :email, type: :string)
          assigner = described_class.new(attribute)
          expect(assigner.value).to match(URI::MailTo::EMAIL_REGEXP)
        end

        it 'returns a meaningful value (example: float "latitude")' do
          attribute = build_attribute(name: :latitude, type: :float)
          assigner = described_class.new(attribute)
          expect(assigner.value).to be_a Float
          expect(assigner.value.to_s).to match(/-?\d+\.\d{9,}/)
        end
      end

      context 'when attribute type does not match accepted types' do
        it 'returns a value that is not meaningful' do
          attribute = build_attribute(name: :latitude, type: :string)
          assigner = described_class.new(attribute)
          expect(assigner.value).to be_a String
          expect(assigner.value).not_to match(/-?\d+\.\d{9,}/)
        end
      end
    end
  end
end
