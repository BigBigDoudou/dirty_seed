# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyAssigner do
  let(:dirty_attribute) { build_dirty_attribute }

  describe '#initialize' do
    context 'when attribute is provided' do
      it 'instantiates an instance' do
        expect(described_class.new(dirty_attribute)).to be_a described_class
      end
    end

    context 'when attribute is not provided' do
      it 'raises an ArgumentError' do
        expect { described_class.new }.to raise_error ArgumentError
      end
    end
  end
end
