# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyBoolean do
  let(:dirty_attribute) { build_dirty_attribute(type: :boolean) }

  describe '#define_value' do
    it 'returns a Boolean' do
      expect(described_class.new(dirty_attribute).define_value).to be_in([true, false])
    end
  end
end
