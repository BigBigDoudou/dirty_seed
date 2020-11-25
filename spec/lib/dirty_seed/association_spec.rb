# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Association do
  let(:model) { DirtySeed::DataModel.charlie }
  let(:reflection) { Charlie.reflections['alfa'] }
  let(:association) { described_class.new(model, reflection) }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(association).to be_a described_class
    end
  end

  describe '#model' do
    it 'returns dirty model' do
      expect(association.model).to eq model
    end
  end

  describe '#name' do
    it 'returns attribute name' do
      expect(association.name).to eq :alfa
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
        model = DirtySeed::DataModel.echo
        reflection = Echo.reflections['echoable']
        association = described_class.new(model, reflection)
        expect(association.associated_models).to eq [Alfa, Charlie]
      end
    end

    context 'when the reflection is cyclic (a belongs to b and b optionnally belongs to a)' do
      it 'returns models accepting this one as polymorphic' do
        model = DirtySeed::DataModel.hotel
        reflection = Hotel.reflections['india']
        association = described_class.new(model, reflection)
        expect(association.associated_models).to eq [India]

        model = DirtySeed::DataModel.india
        reflection = India.reflections['hotel']
        association = described_class.new(model, reflection)
        expect(association.associated_models).to eq [Hotel]
      end
    end
  end
end
