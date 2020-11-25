# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::Boolean do
  let(:attribute) { build_attribute(type: :boolean) }

  describe '#value' do
    it 'returns a Boolean' do
      10.times { expect(described_class.new(attribute).value).to be_in([true, false]) }
    end
  end
end
