# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DirtyAttribute do
  let(:dirty_attribute) { described_class.new(build_dirty_model, build_column) }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(dirty_attribute).to be_a described_class
    end
  end

  describe '#dirty_model' do
    it 'returns dirty model' do
      expect(dirty_attribute.dirty_model).to be_a DirtySeed::DirtyModel
    end
  end

  describe '#type' do
    context 'when column is a boolean' do
      it 'returns :boolean' do
        dirty_attribute = described_class.new(build_dirty_model, build_column(type: :boolean))
        expect(dirty_attribute.type).to eq :boolean
      end
    end

    context 'when column is an integer' do
      it 'returns :integer' do
        dirty_attribute = described_class.new(build_dirty_model, build_column(type: :integer))
        expect(dirty_attribute.type).to eq :integer
      end
    end

    context 'when column is a decimal' do
      it 'returns :float' do
        dirty_attribute = described_class.new(build_dirty_model, build_column(type: :float))
        expect(dirty_attribute.type).to eq :float
      end
    end

    context 'when column is a string' do
      it 'returns :string' do
        dirty_attribute = described_class.new(build_dirty_model, build_column(type: :string))
        expect(dirty_attribute.type).to eq :string
      end
    end
  end
end
