# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Type::Time do
  let(:attribute) { build_attribute(:time) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a Time' do
        10.times { expect(described_class.new(attribute).value).to be_a Time }
      end
    end
  end
end
