# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::DataModel do
  describe '::seed' do
    context 'when ApplicationRecord is defined' do
      it 'seeds instances for each model' do
        expect { described_class.instance.seed(3) }.to change(Alfa, :count).by(3).and change(Golf, :count).by(3)
      end

      context 'when logger is "verbose"' do
        it 'logs seeded records count' do
          expect { described_class.instance.seed(2, verbose: true) }.to output(/seeded: 2/).to_stdout
        end

        it 'logs unique errors' do
          expect { described_class.instance.seed(1, verbose: true) }
            .to output(/(errors:)(.*)(string should be specific)/).to_stdout
        end
      end
    end

    context 'when ApplicationRecord is not defined' do
      it 'puts an error message' do
        hide_const('ApplicationRecord')
        expect { described_class.instance.seed(1) }.to raise_error NameError
      end
    end
  end

  describe '::models' do
    it 'returns an array of dirty models representing Active Record models' do
      expect(described_class.instance.models.map(&:name)).to match_array(
        %w[Alfa Bravo Charlie Delta Echo Foxtrot Golf Hotel India Juliett]
      )
    end

    it 'returns an array sorted by association' do
      models = described_class.instance.models.map(&:__getobj__)
      expect(models.index(Alfa)).to be < models.index(Delta)
      expect(models.index(Alfa)).to be < models.index(Echo)
      expect(models.index(Hotel)).to be < models.index(India)
    end
  end

  describe '::active_record_models' do
    let(:active_record_models) { described_class.instance.active_record_models }

    it 'returns an array of Active Record models' do
      expect(active_record_models).to match_array(
        [Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Juliett]
      )
    end
  end
end
