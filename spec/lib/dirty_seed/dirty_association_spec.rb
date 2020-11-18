# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DirtyAssociation do
  let(:dirty_model)       { DirtySeed::DataModel.charlie }
  let(:reflection)        { Charlie.reflections['alfa'] }
  let(:dirty_association) { described_class.new(dirty_model, reflection) }

  describe '#initialize' do
    it 'instantiates an instance' do
      expect(dirty_association).to be_a described_class
    end
  end

  describe '#dirty_model' do
    it 'returns dirty model' do
      expect(dirty_association.dirty_model).to eq dirty_model
    end
  end

  describe '#name' do
    it 'returns attribute name' do
      expect(dirty_association.name).to eq :alfa
    end
  end

  describe '#attribute' do
    it 'returns attribute of this association' do
      expect(dirty_association.attribute).to eq :alfa_id
    end
  end

  describe '#associated_models' do
    context 'when the reflection is regular' do
      it 'returns belongs_to association' do
        expect(dirty_association.associated_models).to eq [Alfa]
      end
    end

    context 'when the reflection is polymorphic' do
      it 'returns models associated with has_many or has_one' do
        dirty_model = DirtySeed::DataModel.echo
        reflection = Echo.reflections['echoable']
        dirty_association = described_class.new(dirty_model, reflection)
        expect(dirty_association.associated_models).to eq [Alfa, Charlie]
      end
    end

    context 'when the reflection is cyclic (a belongs to b and b optionnally belongs to a)' do
      it 'returns models accepting this one as polymorphic' do
        dirty_model = DirtySeed::DataModel.hotel
        reflection = Hotel.reflections['india']
        dirty_association = described_class.new(dirty_model, reflection)
        expect(dirty_association.associated_models).to eq [India]

        dirty_model = DirtySeed::DataModel.india
        reflection = India.reflections['hotel']
        dirty_association = described_class.new(dirty_model, reflection)
        expect(dirty_association.associated_models).to eq [Hotel]
      end
    end
  end
end
