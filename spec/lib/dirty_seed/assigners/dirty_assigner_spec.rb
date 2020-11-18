# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyAssigner do
  let(:dirty_attribute) { build_dirty_attribute }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(described_class.new(dirty_attribute, 0)).to be_a described_class
    end
  end
end
