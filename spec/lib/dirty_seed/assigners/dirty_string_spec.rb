# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyString do
  let(:dirty_attribute) { build_dirty_attribute(type: :string) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a String' do
        expect(described_class.new(dirty_attribute, 0).value).to be_a String
      end
    end

    context 'when meaning can be guessed' do
      it 'returns a meaningfull String' do
        email_attribute = build_dirty_attribute(name: 'email', type: :string)
        10.times do
          value = described_class.new(email_attribute, 0).value
          expect(URI::MailTo::EMAIL_REGEXP.match?(value)).to be true
        end
      end
    end
  end
end
