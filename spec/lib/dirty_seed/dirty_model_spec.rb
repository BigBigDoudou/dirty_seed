# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DirtyModel do
  let(:data_model) { DirtySeed::DataModel }

  describe '#initialize(model:)' do
    context 'when <:model> inherits from ActiveRecord::Base' do
      it 'instantiates an instance' do
        expect(described_class.new(model: Alfa)).to be_a described_class
      end
    end

    context 'when <:model> does not inherit from ActiveRecord::Base' do
      it 'raises an ArgumentError' do
        expect { described_class.new(model: Object) }.to raise_error ArgumentError
      end
    end
  end

  describe '#seed(count)' do
    it 'tries to create <count> instances of the model' do
      expect { data_model.alfa.seed(3) }.to change { Alfa.count }.by(3)
    end

    it 'counts the number of successfully seeded instances' do
      data_model.alfa.seed(3)
      expect(data_model.alfa.count).to eq 3
    end

    it 'logs the errors' do
      Alfa.create!
      data_model.juliet.seed(3)
      expect(data_model.juliet.errors).to match_array(
        [
          'Alfa should be some specific alfa',
          'String should be a specific string',
          'Integer should be a specific integer'
        ]
      )
    end
  end

  describe '#associations' do
    it 'returns associations' do
      expect(data_model.alfa.associations.count).to eq 0
      expect(data_model.bravo.associations.count).to eq 0
      expect(data_model.charlie.associations.count).to eq 1
      expect(data_model.delta.associations.count).to eq 2
      expect(data_model.echo.associations.count).to eq 1
      expect(data_model.foxtrot.associations.count).to eq 0
      expect(data_model.golf.associations.count).to eq 0
      expect(data_model.hotel.associations.count).to eq 1
      expect(data_model.india.associations.count).to eq 1
    end
  end

  describe '#associated_models' do
    it 'returns belongs_to models' do
      expect(data_model.alfa.associated_models).to be_empty
      expect(data_model.bravo.associated_models).to be_empty
      expect(data_model.charlie.associated_models).to match_array([Alfa])
      expect(data_model.delta.associated_models).to match_array([Bravo, Charlie])
      expect(data_model.echo.associated_models).to match_array([Alfa, Charlie])
      expect(data_model.foxtrot.associated_models).to be_empty
      expect(data_model.golf.associated_models).to be_empty
      expect(data_model.hotel.associated_models).to match_array([India])
      expect(data_model.india.associated_models).to match_array([Hotel])
    end
  end

  describe '#attributes' do
    it 'defines attributes' do
      expect(data_model.alfa.attributes.count).to eq 7
      expect(data_model.bravo.attributes.count).to eq 4
      expect(data_model.charlie.attributes.count).to eq 0
      expect(data_model.delta.attributes.count).to eq 0
      expect(data_model.echo.attributes.count).to eq 0
      expect(data_model.foxtrot.attributes.count).to eq 1
      expect(data_model.golf.attributes.count).to eq 1
      expect(data_model.hotel.attributes.count).to eq 0
      expect(data_model.india.attributes.count).to eq 0
    end
  end

  describe '#method_missing' do
    context 'when model respond to the method' do
      it 'calls method on model' do
        expect(DirtySeed::DirtyModel.instance_methods(false)).to_not include :name
        expect(Alfa.methods).to include :name
        expect(data_model.alfa.name).to eq Alfa.name
      end
    end

    context 'when model does not respond to the method' do
      it 'raises a NoMethodError' do
        expect(DirtySeed::DirtyModel.instance_methods(false)).to_not include :foo
        expect(Alfa.methods).to_not include :foo
        expect { data_model.alfa.foo }.to raise_error NoMethodError
      end
    end
  end
end
