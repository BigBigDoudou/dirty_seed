# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Attribute do
  describe '#initialize' do
    it 'builds an instance' do
      attribute = described_class.new(build_column(:string))
      expect(attribute).to be_a described_class
    end
  end

  describe '#array?' do
    context 'when attribute is not an array' do
      it 'returns false' do
        attribute = described_class.new(build_column(:string))
        expect(attribute.array?).to be false
      end
    end

    context 'when column is an array (text[])' do
      it 'returns true' do
        attribute = described_class.new(build_column(:'string[]'))
        expect(attribute.array?).to be true
      end
    end

    context 'when attribute is serialized (serialize :attribute, Array)' do
      it 'returns true' do
        column = Bravo.columns.find { |c| c.name == 'an_array' }
        attribute = described_class.new(column)
        attribute.model = Bravo
        expect(attribute.array?).to be true
      end
    end
  end

  describe '#type' do
    context 'when column is a boolean' do
      it 'returns :boolean' do
        attribute = described_class.new(build_column(:boolean))
        expect(attribute.type).to eq :boolean
      end
    end

    context 'when column is an integer' do
      it 'returns :integer' do
        attribute = described_class.new(build_column(:integer))
        expect(attribute.type).to eq :integer
      end
    end

    context 'when column is a decimal' do
      it 'returns :float' do
        attribute = described_class.new(build_column(:float))
        expect(attribute.type).to eq :float
      end
    end

    context 'when column is a string' do
      it 'returns :string' do
        attribute = described_class.new(build_column(:string))
        expect(attribute.type).to eq :string
      end
    end

    context 'when column is an array of integers' do
      it 'returns :string' do
        attribute = described_class.new(build_column(:'string[]'))
        expect(attribute.type).to eq :string
      end
    end
  end
end
