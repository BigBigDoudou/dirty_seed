# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyAssigner do
  let(:dirty_attribute) { build_dirty_attribute(type: :integer) }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(described_class.new(dirty_attribute)).to be_a described_class
    end
  end

  describe 'absent' do
    context 'when value should be absent' do
      it 'returns nil' do
        bravos = DirtySeed::DataModel.bravo.seed(10)
        expect(bravos.map(&:an_absent_value).all?(&:nil?)).to be true
      end
    end
  end

  describe 'inclusion' do
    context 'when value should be one of options' do
      let(:bravos) { DirtySeed::DataModel.bravo.seed(10) }

      it 'returns a value from options [strings]' do
        expect(
          bravos.map(&:a_string_from_options).all? { |v| v.in? %w[foo bar zed] }
        ).to be true
      end

      it 'returns a value from options [integers]' do
        expect(
          bravos.map(&:an_integer_from_options).all? { |v| v.in? [15, 30, 45] }
        ).to be true
      end
    end
  end

  describe 'uniqueness' do
    context 'when value should be unique' do
      it 'returns unique values or nil' do
        bravos = DirtySeed::DataModel.bravo.seed(20)
        expect(bravos.map(&:a_unique_value).count(&:nil?)).to eq 10
        expect(bravos.map(&:a_unique_value).compact).to eq bravos.map(&:a_unique_value).compact.uniq
      end
    end
  end

  describe '#unique?', skip: 'has been set private' do
    let(:assigner) { described_class.new(dirty_attribute) }

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
