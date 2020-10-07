# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Sorter do
  describe '#initialize' do
    context 'when arguments are valid' do
      it 'instantiates an instance' do
        expect(described_class.new(models: [Alfa, Bravo])).to be_a described_class
      end
    end

    context 'when all models do not inherit from ActiveRecord::Base' do
      it 'raises an ArgumentError' do
        expect { described_class.new(models: [Alfa, Object]) }.to raise_error ArgumentError
      end
    end
  end

  describe '#sort' do
    it 'returns an empty array if models is empty' do
      sorted = DirtySeed::Sorter.new(models: []).sort!
      expect(sorted).to be_empty
    end

    it 'sorts models by dependencies [1]' do
      sorted = DirtySeed::Sorter.new(models: [Alfa, Charlie]).sort!
      expect(sorted).to eq([Alfa, Charlie])
    end

    it 'sorts models by dependencies [2]' do
      sorted = DirtySeed::Sorter.new(models: [Charlie, Alfa]).sort!
      expect(sorted).to eq([Alfa, Charlie])
    end

    it 'sorts models by dependencies [3]' do
      10.times do
        sorted = DirtySeed::Sorter.new(models: active_record_models.shuffle).sort!
        expect(sorted.index(Alfa)).to be < sorted.index(Delta)
        expect(sorted.index(Alfa)).to be < sorted.index(Echo)
        expect(sorted.index(Charlie)).to be < sorted.index(Echo)
        expect(sorted.index(Hotel)).to be < sorted.index(India)
      end
    end

    context 'when infinite loop could happens' do
      it 'does not raise error' do
        sorted = DirtySeed::Sorter.new(models: [India, Hotel]).sort!
        expect(sorted).to eq([Hotel, India])
      end
    end
  end
end
