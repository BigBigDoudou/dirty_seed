# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyAssigner do
  let(:attribute) do
    DirtySeed::DirtyAttribute.new(
      column: ActiveRecord::ConnectionAdapters::Column.new(
        'boolean',
        false,
        ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: :boolean)
      )
    )
  end

  describe '#initialize' do
    context 'when arguments are valid' do
      it 'instantiates an instance' do
        expect(described_class.new(attribute: attribute)).to be_a described_class
      end
    end

    context 'when model does not inherit from ActiveRecord::Base' do
      it 'raises an ArgumentError' do
        expect { described_class.new(attribute: Object) }.to raise_error ArgumentError
      end
    end
  end
end
