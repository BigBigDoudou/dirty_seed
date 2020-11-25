# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyTime do
  let(:dirty_attribute) { build_dirty_attribute(type: :time) }

  describe '#define_value' do
    context 'when there are no validators' do
      it 'returns a Time' do
        expect(described_class.new(dirty_attribute).define_value).to be_a Time
      end
    end
  end
end
