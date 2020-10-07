# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyString do
  describe '#value' do
    context 'when there are no validators' do
      it 'returns a String' do
        expect(described_class.new.value).to be_a String
      end
    end
  end
end
