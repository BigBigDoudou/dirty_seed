# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyDate do
  describe '#value' do
    context 'when there are no validators' do
      it 'returns a Date' do
        expect(described_class.new.value).to be_a Date
      end
    end
  end
end
