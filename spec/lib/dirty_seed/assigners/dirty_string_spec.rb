# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyString do
  let(:data_model) { DirtySeed::DataModel }
  let(:dirty_attribute) { build_dirty_attribute(type: :string) }

  describe '#define_value' do
    context 'when there are no validators' do
      it 'returns a String' do
        expect(described_class.new(dirty_attribute).define_value).to be_a String
      end
    end

    context 'when value should match pattern' do
      it 'returns a value matching the pattern' do
        dirty_attribute = build_dirty_attribute(type: :string)
        assigner = described_class.new(dirty_attribute)
        regex = /\w{10}@(hotmail|gmail)\.com/
        validator = ActiveModel::Validations::FormatValidator.new(attributes: :fake, with: regex)
        allow(assigner.dirty_attribute).to receive(:validators).and_return([validator])
        expect(assigner.value).to match(regex)
      end
    end

    context 'when meaning can be guessed' do
      it 'returns a meaningfull String [email]' do
        email_attribute = build_dirty_attribute(name: :email, type: :string)
        assigner = described_class.new(email_attribute)
        expect(assigner.value).to match(URI::MailTo::EMAIL_REGEXP)
      end

      it 'returns a meaningfull String [latitude]' do
        latitude_attribute = build_dirty_attribute(name: :latitude, type: :string)
        assigner = described_class.new(latitude_attribute)
        expect(assigner.value.to_s).to match(/-?\d+\.\d+/)
      end

      it 'returns a meaningfull String [locale]' do
        locale_attribute = build_dirty_attribute(name: :locale, type: :string)
        assigner = described_class.new(locale_attribute)
        expect(assigner.value).to match(/[A-Z]{2}/)
      end

      it 'returns a meaningfull String [uuid]' do
        uuid_attribute = build_dirty_attribute(name: :uuid, type: :string)
        assigner = described_class.new(uuid_attribute)
        expect(assigner.value).to match(/([a-z]|-|\d){36}/)
      end
    end
  end
end
