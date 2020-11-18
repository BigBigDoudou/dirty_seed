# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyTime do
  let(:dirty_attribute) { build_dirty_attribute(type: :time) }

  describe '#value' do
    context 'when there are no validators' do
      it 'returns a Time' do
        expect(described_class.new(dirty_attribute, 0).value).to be_a Time
      end
    end
  end
end
