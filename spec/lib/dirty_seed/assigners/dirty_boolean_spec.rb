# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyBoolean do
  describe '#value' do
    it 'returns a Boolean' do
      expect([true, false]).to include described_class.new.value
    end
  end
end
