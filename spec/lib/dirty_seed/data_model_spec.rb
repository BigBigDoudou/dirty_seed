# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DataModel do
  describe '::seed' do
    context 'when ApplicationRecord is defined' do
      it 'seeds instances for each model' do
        described_class.seed
        [Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India].each do |active_record_model|
          expect(active_record_model.count).to be > 0
        end
      end
    end

    context 'when ApplicationRecord is not defined' do
      it 'puts an error message' do
        hide_const('ApplicationRecord')
        expect { described_class.seed }.to raise_error NameError
      end
    end
  end

  describe '::print_logs' do
    it 'prints logs in the console' do
      described_class.seed
    end
  end

  describe '::models' do
    it 'returns an array of dirty models representing Active Record models' do
      expect(described_class.models.map(&:name)).to match_array(
        %w[Alfa Bravo Charlie Delta Echo Foxtrot Golf Hotel India Juliet]
      )
    end
  end

  describe '::active_record_models' do
    let(:active_record_models) { described_class.active_record_models }

    it 'returns an array of Active Record models' do
      expect(active_record_models).to match_array(
        [Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Juliet]
      )
    end

    it 'sorts models with associations' do
      expect(active_record_models.index(Alfa)).to be < active_record_models.index(Delta)
      expect(active_record_models.index(Alfa)).to be < active_record_models.index(Echo)
      expect(active_record_models.index(Alfa)).to be < active_record_models.index(Juliet)
      expect(active_record_models.index(Charlie)).to be < active_record_models.index(Echo)
    end
  end

  describe '#method_missing' do
    context 'when method_name matches an ActiveRecord model' do
      it 'returns the related dirty model' do
        dirty_alfa = described_class.models.find { |dirty_model| dirty_model.model == Alfa }
        expect(described_class.respond_to_missing?(:alfa)).to be true
        expect(described_class.alfa).to eq dirty_alfa
      end
    end

    context 'when method_name does not match an ActiveRecord model' do
      it 'raises a NoMethodError' do
        expect(described_class.respond_to_missing?(:foo)).to be false
        expect { described_class.foo }.to raise_error NoMethodError
      end
    end
  end
end
