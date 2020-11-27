# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Type::String do
  let(:attribute) { build_attribute(:string) }
  let(:assigner) { described_class.new(attribute) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a String' do
        expect(assigner.value).to be_a String
      end
    end

    context 'when value should match pattern' do
      context 'when pattern is readable' do
        it 'returns a value matching the pattern' do
          regex = /\w{10}@(hotmail|gmail)\.com/
          attribute.validators = [
            ActiveModel::Validations::FormatValidator.new(attributes: :fake, with: regex)
          ]
          10.times { expect(assigner.value).to match(regex) }
        end
      end

      context 'when pattern is not readable' do
        it 'returns nil' do
          attribute.validators = [
            ActiveModel::Validations::FormatValidator.new(attributes: :fake, with: URI::DEFAULT_PARSER.make_regexp)
          ]
          10.times { expect(assigner.value).to be_nil }
        end
      end
    end

    context 'when the length has a minimim validation' do
      it 'returns a value with the required length' do
        attribute.validators = [
          ActiveRecord::Validations::LengthValidator.new(attributes: :fake, minimum: 5)
        ]
        10.times { expect(assigner.value.length).to be >= 5 }
      end
    end

    context 'when the length has a maximum validation' do
      it 'returns a value with the required length' do
        attribute.validators = [
          ActiveRecord::Validations::LengthValidator.new(attributes: :fake, maximum: 5)
        ]
        10.times { expect(assigner.value.length).to be <= 5 }
      end
    end
  end
end
