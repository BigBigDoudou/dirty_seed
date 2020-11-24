# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyAssigner do
  let(:dirty_attribute) { build_dirty_attribute }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(described_class.new(dirty_attribute, 0)).to be_a described_class
    end
  end

  describe '#unique?' do
    let(:assigner) { described_class.new(dirty_attribute, 0) }

    context 'when there is a uniqueness validation' do
      it 'returns true' do
        validator = ActiveModel::Validations::NumericalityValidator.new(attributes: :fake, uniqueness: true)
        allow(assigner.dirty_attribute).to receive(:validators).and_return([validator])
        expect(assigner.unique?).to be true
      end
    end

    context 'when there is no uniqueness validation' do
      it 'returns false' do
        expect(assigner.unique?).to be false
      end
    end
  end
end
