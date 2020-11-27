# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Sorter do
  let(:alfa) { build_model(Alfa) }
  let(:bravo) { build_model(Bravo) }
  let(:charlie) { build_model(Charlie) }

  describe '#initialize' do
    it 'builds an instance' do
      expect(described_class.new([alfa, bravo])).to be_a described_class
    end
  end

  describe '#sort' do
    it 'returns an empty array if models is empty' do
      sorted = described_class.new([]).sort
      expect(sorted).to be_empty
    end

    it 'sorts models by dependencies [1]' do
      sorted = described_class.new([alfa, charlie]).sort
      expect(sorted).to eq([alfa, charlie])
    end

    it 'sorts models by dependencies [2]' do
      sorted = described_class.new([charlie, alfa]).sort
      expect(sorted).to eq([alfa, charlie])
    end

    it 'sorts models by dependencies [3]' do # rubocop:disable RSpec/ExampleLength
      delta = build_model(Delta)
      echo = build_model(Echo)
      hotel = build_model(Hotel)
      india = build_model(India)
      active_record_models = [alfa, charlie, delta, echo, hotel, india]
      10.times do
        sorted = described_class.new(active_record_models.shuffle).sort
        expect(sorted.index(alfa)).to be < sorted.index(delta)
        expect(sorted.index(alfa)).to be < sorted.index(echo)
        expect(sorted.index(hotel)).to be < sorted.index(india)
      end
    end

    context 'when infinite loop could happens' do
      it 'does not raise error' do
        hotel = build_model(Hotel)
        india = build_model(India)
        sorted = described_class.new([india, hotel]).sort
        expect(sorted).to eq([hotel, india])
      end
    end
  end
end
