# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DirtyAttribute do
  let(:sql_type) { ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: :boolean) }
  let(:column) { ActiveRecord::ConnectionAdapters::Column.new('boolean', false, sql_type) }
  let(:dirty_attribute) { described_class.new(dirty_model: DirtySeed::DirtyModel.new, column: column) }

  describe '#initialize' do
    context 'when arguments are valid' do
      it 'instantiates an instance' do
        expect(dirty_attribute).to be_a described_class
        expect(described_class.new).to be_a described_class
      end
    end

    context 'when dirty_model is not a DirtySeed::DirtyModel' do
      it 'raises an ArgumentError' do
        expect { described_class.new(dirty_model: Alfa) }.to raise_error ArgumentError
      end
    end

    context 'when column is not a ActiveRecord::ConnectionAdapters::Column' do
      it 'raises an ArgumentError' do
        expect { described_class.new(column: 42) }.to raise_error ArgumentError
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
      it 'returns :boolean' do
        sql_type = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: :boolean)
        column = ActiveRecord::ConnectionAdapters::Column.new('boolean', false, sql_type)
        expect(described_class.new(column: column).type).to eq :boolean
      end
    end

    context 'when column is an integer' do
      it 'returns :integer' do
        sql_type = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: :integer)
        column = ActiveRecord::ConnectionAdapters::Column.new('integer', 1, sql_type)
        expect(described_class.new(column: column).type).to eq :integer
      end
    end

    context 'when column is a decimal' do
      it 'returns :float' do
        sql_type = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: :decimal)
        column = ActiveRecord::ConnectionAdapters::Column.new('decimal', 1.0, sql_type)
        expect(described_class.new(column: column).type).to eq :float
      end
    end

    context 'when column is a string' do
      it 'returns :string' do
        sql_type = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: :string)
        column = ActiveRecord::ConnectionAdapters::Column.new(:string, '', sql_type)
        expect(described_class.new(column: column).type).to eq :string
      end
    end

    context 'when column is a sti type' do
      it 'returns :string' do
        sql_type = ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: :string)
        column = ActiveRecord::ConnectionAdapters::Column.new('type', '', sql_type)
        expect(described_class.new(column: column).type).to eq :sti_type
      end
    end
  end
end
