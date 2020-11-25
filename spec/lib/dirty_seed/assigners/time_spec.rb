# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Time do
  let(:attribute) { build_attribute(type: :time) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a Time' do
        expect(described_class.new(attribute).value).to be_a Time
      end
    end
  end
end
