# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Association do
  let(:reflection) { Charlie.reflections['alfa'] }
  let(:association) { described_class.new(reflection) }

  describe '#initialize' do
    it 'builds an instance' do
      expect(association).to be_a described_class
    end
  end

  describe '#attribute' do
    it 'returns attribute of this association' do
      expect(association.attribute).to eq :alfa_id
    end
  end

  describe '#associated_models' do
    context 'when the reflection is regular' do
      it 'returns belongs_to association' do
        expect(association.associated_models).to eq [Alfa]
      end
    end

    context 'when the reflection is polymorphic' do
      it 'returns models associated with has_many or has_one' do
        association = described_class.new(Echo.reflections['echoable'])
        expect(association.associated_models).to eq [Alfa, Charlie]
      end
    end

    context 'when the reflection is cyclic (a belongs to b and b optionnally belongs to a)' do
      it 'returns models accepting this one as polymorphic' do
        association = described_class.new(Hotel.reflections['india'])
        expect(association.associated_models).to eq [India]
        association = described_class.new(India.reflections['hotel'])
        expect(association.associated_models).to eq [Hotel]
      end
    end
  end
end
