# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyBoolean do
  let(:dirty_attribute) { build_dirty_attribute(type: :boolean) }

  describe '#value' do
    it 'returns a Boolean' do
      expect([true, false]).to include described_class.new(dirty_attribute).value
    end
  end
end
