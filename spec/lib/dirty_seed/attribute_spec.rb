# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Attribute do
  let(:attribute) { described_class.new(build_model, build_column) }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(attribute).to be_a described_class
    end
  end

  describe '#model' do
    it 'returns dirty model' do
      expect(attribute.model).to be_a DirtySeed::Model
    end
  end

  describe '#type' do
    context 'when column is a boolean' do
      it 'returns :boolean' do
        attribute = described_class.new(build_model, build_column(type: :boolean))
        expect(attribute.type).to eq :boolean
      end
    end

    context 'when column is an integer' do
      it 'returns :integer' do
        attribute = described_class.new(build_model, build_column(type: :integer))
        expect(attribute.type).to eq :integer
      end
    end

    context 'when column is a decimal' do
      it 'returns :float' do
        attribute = described_class.new(build_model, build_column(type: :float))
        expect(attribute.type).to eq :float
      end
    end

    context 'when column is a string' do
      it 'returns :string' do
        attribute = described_class.new(build_model, build_column(type: :string))
        expect(attribute.type).to eq :string
      end
    end
  end
end
