# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Type::Date do
  let(:attribute) { build_attribute(:date) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a Date' do
        10.times { expect(described_class.new(attribute).value).to be_a Date }
      end
    end
  end
end
