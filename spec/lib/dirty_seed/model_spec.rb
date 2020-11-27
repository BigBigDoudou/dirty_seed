# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Model do
  let(:data_model) { DirtySeed::DataModel }

  describe '#initialize(active_record_model)' do
    it 'builds an instance' do
      expect(described_class.new(Alfa)).to be_a described_class
    end
  end

  describe '#associations' do
    it 'returns associations' do
      expect(described_class.new(Alfa).associations).to be_empty
      expect(described_class.new(Delta).associations.count).to eq 2
      expect(described_class.new(Echo).associations.count).to eq 1
    end
  end

  describe '#associated_models' do
    it 'returns belongs_to models' do
      expect(described_class.new(Alfa).associated_models).to be_empty
      expect(described_class.new(Delta).associated_models).to match_array([Bravo, Charlie])
      expect(described_class.new(Echo).associated_models).to match_array([Alfa, Charlie])
    end
  end

  describe '#attributes' do
    it 'builds and returns attributes' do
      expectations = %w[a_boolean an_integer a_decimal a_string a_date a_time a_datetime]
      expect(described_class.new(Alfa).attributes.map(&:name)).to match_array(expectations)
    end

    it 'does not instantiate a dirty attribute for "protected columns"' do
      expect(
        described_class.new(Alfa).attributes.map(&:name) & described_class::PROTECTED_COLUMNS
      ).to be_empty
    end
  end
end
