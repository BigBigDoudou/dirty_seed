# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Type::Json do
  let(:attribute) { build_attribute(:json) }
  let(:assigner) { described_class.new(attribute) }

  describe '#value' do
    it 'returns a Hash' do
      expect(assigner.value).to be_a Hash
    end
  end
end
