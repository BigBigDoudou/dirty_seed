# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Model do
  let(:data_model) { DirtySeed::DataModel }

  describe '#initialize(model:)' do
    it 'instantiates an instance' do
      expect(described_class.new(Alfa)).to be_a described_class
    end
  end

  describe '#seed(count)' do
    it 'tries to create x instances of the model' do
      expect { data_model.alfa.seed(3) }.to change(Alfa, :count).by(3)
    end

    it 'stores the number of successfully seeded instances' do
      data_model.alfa.seed(3)
      expect(data_model.alfa.instances.count).to eq 3
    end

    it 'stores the errors' do
      Alfa.create && data_model.juliett.seed(3)
      expect(data_model.juliett.errors).to match_array(
        [
          'Alfa should be some specific alfa',
          'A string should be a specific string',
          'An integer should be a specific integer'
        ]
      )
    end
  end

  describe '#associations' do
    it 'returns associations' do
      expect(data_model.alfa.associations).to be_empty
      expect(data_model.delta.associations.count).to eq 2
      expect(data_model.echo.associations.count).to eq 1
    end
  end

  describe '#associated_models' do
    it 'returns belongs_to models' do
      expect(data_model.alfa.associated_models).to be_empty
      expect(data_model.delta.associated_models).to match_array([Bravo, Charlie])
      expect(data_model.echo.associated_models).to match_array([Alfa, Charlie])
    end
  end

  describe '#attributes' do
    it 'instantiates and returns attributes' do
      expectations = %i[a_boolean an_integer a_decimal a_string a_date a_time a_datetime]
      expect(data_model.alfa.attributes.map(&:name)).to match_array(expectations)
    end

    it 'does not instantiate a dirty attribute for "protected columns"' do
      expect(
        data_model.alfa.attributes.map(&:name) & described_class::PROTECTED_COLUMNS
      ).to be_empty
    end
  end

  describe '#method_missing' do
    context 'when model respond to the method' do
      it 'calls method on model' do
        expect(described_class.instance_methods(false)).not_to include :name
        expect(Alfa.methods).to include :name
        expect(data_model.alfa.name).to eq Alfa.name
      end
    end

    context 'when model does not respond to the method' do
      it 'raises a NoMethodError' do
        expect(described_class.instance_methods(false)).not_to include :foo
        expect(Alfa.methods).not_to include :foo
        expect { data_model.alfa.foo }.to raise_error NoMethodError
      end
    end
  end
end
