# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Sorter do
  describe '#initialize' do
    it 'instantiates an instance' do
      expect(described_class.new([Alfa, Bravo])).to be_a described_class
    end
  end

  describe '#sort' do
    it 'returns an empty array if models is empty' do
      sorted = described_class.new([]).sort!
      expect(sorted).to be_empty
    end

    it 'sorts models by dependencies [1]' do
      sorted = described_class.new([Alfa, Charlie]).sort!
      expect(sorted).to eq([Alfa, Charlie])
    end

    it 'sorts models by dependencies [2]' do
      sorted = described_class.new([Charlie, Alfa]).sort!
      expect(sorted).to eq([Alfa, Charlie])
    end

    it 'sorts models by dependencies [3]' do
      active_record_models = [Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Juliett]
      10.times do
        sorted = described_class.new(active_record_models.shuffle).sort!
        expect(sorted.index(Alfa)).to be < sorted.index(Delta)
        expect(sorted.index(Alfa)).to be < sorted.index(Echo)
        expect(sorted.index(Hotel)).to be < sorted.index(India)
      end
    end

    context 'when infinite loop could happens' do
      it 'does not raise error' do
        sorted = described_class.new([India, Hotel]).sort!
        expect(sorted).to eq([Hotel, India])
      end
    end
  end
end
