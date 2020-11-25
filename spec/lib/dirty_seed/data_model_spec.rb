# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DataModel do
  describe '::seed' do
    context 'when ApplicationRecord is defined' do
      it 'seeds instances for each model' do
        expect { described_class.seed(3) }.to change(Alfa, :count).by(3).and change(Golf, :count).by(3)
      end

      it 'logs data' do
        expect { described_class.seed(1) }.to output(/Alfa/).to_stdout
        expect { described_class.seed(2) }.to output(/seeded: 2/).to_stdout
        expect { described_class.seed(1) }.to output(/(errors:)(.*)(A string should be a specific string)/).to_stdout
      end
    end

    context 'when ApplicationRecord is not defined' do
      it 'puts an error message' do
        hide_const('ApplicationRecord')
        expect { described_class.seed(1) }.to raise_error NameError
      end
    end
  end

  describe '::models' do
    it 'returns an array of dirty models representing Active Record models' do
      expect(described_class.models.map(&:name)).to match_array(
        %w[Alfa Bravo Charlie Delta Echo Foxtrot Golf Hotel India Juliett]
      )
    end
  end

  describe '::active_record_models' do
    let(:active_record_models) { described_class.active_record_models }

    it 'returns an array of Active Record models' do
      expect(active_record_models).to match_array(
        [Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Juliett]
      )
    end

    it 'sorts models with associations' do
      expect(active_record_models.index(Alfa)).to be < active_record_models.index(Delta)
      expect(active_record_models.index(Alfa)).to be < active_record_models.index(Echo)
      expect(active_record_models.index(Charlie)).to be < active_record_models.index(Echo)
    end
  end

  describe '#method_missing' do
    context 'when method_name matches an ActiveRecord model' do
      it 'returns the related dirty model' do
        dirty_alfa = described_class.models.find { |model| model.model == Alfa }
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
