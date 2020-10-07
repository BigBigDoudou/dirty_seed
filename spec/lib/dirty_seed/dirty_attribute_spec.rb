# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DirtyAttribute do
  let(:dirty_model) { DirtySeed::DirtyModel.new(model: Alfa) }
  let(:column) { Alfa.columns.find { |c| c.name == 'boolean' } }
  let(:dirty_attribute) { described_class.new(dirty_model: dirty_model, column: column) }

  describe '#initialize' do
    context 'when arguments are valid' do
      it 'instantiates an instance' do
        expect(dirty_attribute).to be_a described_class
      end
    end

    context 'when dirty_model is not a DirtySeed::DirtyModel' do
      it 'raises an ArgumentError' do
        expect { described_class.new(dirty_model: Alfa, column: column) }.to raise_error ArgumentError
      end
    end

    context 'when column is not a ActiveRecord::ConnectionAdapters::Column' do
      it 'raises an ArgumentError' do
        expect { described_class.new(dirty_model: dirty_model, column: {}) }.to raise_error ArgumentError
      end
    end
  end

  describe '#dirty_model' do
    it 'returns dirty model' do
      expect(dirty_attribute.dirty_model).to be_a DirtySeed::DirtyModel
    end
  end

  describe '#model' do
    it 'returns dirty model' do
      expect(dirty_attribute.model).to be_a DirtySeed::DirtyModel
    end
  end

  describe '#type' do
    context 'when column is a boolean' do
      let(:dirty_boolean) do
        described_class.new(
          dirty_model: dirty_model,
          column: Alfa.columns.find { |c| c.name == 'boolean' }
        )
      end
      it 'returns :boolean' do
        expect(dirty_boolean.type).to eq :boolean
      end
    end

    context 'when column is an integer' do
      let(:dirty_integer) do
        described_class.new(
          dirty_model: dirty_model,
          column: Alfa.columns.find { |c| c.name == 'integer' }
        )
      end
      it 'returns :integer' do
        expect(dirty_integer.type).to eq :integer
      end
    end

    context 'when column is a decimal' do
      let(:dirty_float) do
        described_class.new(
          dirty_model: dirty_model,
          column: Alfa.columns.find { |c| c.name == 'decimal' }
        )
      end
      it 'returns :float' do
        expect(dirty_float.type).to eq :float
      end
    end

    context 'when column is a string' do
      let(:dirty_string) do
        described_class.new(
          dirty_model: dirty_model,
          column: Alfa.columns.find { |c| c.name == 'string' }
        )
      end
      it 'returns :string' do
        expect(dirty_string.type).to eq :string
      end
    end

    context 'when column is a sti type' do
      let(:dirty_sti_type) do
        described_class.new(
          dirty_model: DirtySeed::DirtyModel.new(model: Foxtrot),
          column: Foxtrot.columns.find { |c| c.name == 'type' }
        )
      end
      it 'returns :sti_type' do
        expect(dirty_sti_type.type).to eq :sti_type
      end
    end
  end
end
