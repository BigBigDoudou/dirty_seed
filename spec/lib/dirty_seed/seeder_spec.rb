# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Seeder do
  let(:data_model) { DirtySeed::DataModel }
  let(:alfa) { DirtySeed::Model.new(Alfa) }

  describe '#initialize(model)' do
    it 'builds an instance' do
      expect(described_class.new(alfa)).to be_a described_class
    end
  end

  describe '#seed(count)' do
    it 'tries to create x records of the model' do
      expect { described_class.new(DirtySeed::Model.new(Bravo)).seed(3) }.to change(Bravo, :count).by(3)
    end

    it 'stores the number of successfully seeded records' do
      seeder = described_class.new(alfa)
      seeder.seed(3)
      expect(seeder.records.count).to eq 3
    end

    context 'when it raises ActiveRecord::RecordInvalid error' do
      it 'stores the error' do
        seeder = described_class.new(DirtySeed::Model.new(Juliett))
        seeder.seed(1)
        expect(seeder.errors).to include('A string should be specific')
      end
    end

    context 'when it raises another StandardError' do
      let(:seeder) { described_class.new(alfa) }

      context 'when it happens on initialize' do
        let(:bad_string) { '39763e57-f8a0-483a-8b26-cc670de8cbfd' }

        before do
          allow(seeder).to receive(:params_collection).and_return([{ a_string: bad_string }])
        end

        it 'rescues from StandardError' do
          expect { Alfa.new(a_string: bad_string) }.to raise_error StandardError
          expect { seeder.seed(1) }.not_to raise_error
        end

        it 'cleans and adds error message to the errors list' do
          seeder.seed(10)
          expect(seeder.errors.count).to eq 1
          expect(seeder.errors.first.length).to be <= 200
          expect(seeder.errors.first).not_to include("\n")
        end
      end

      context 'when it happens on save' do
        let(:bad_string) { '5ecb793c-e0fd-4315-b60d-66f34c1c17e3' }

        before do
          allow(seeder).to receive(:params_collection).and_return([{ a_string: bad_string }])
        end

        it 'rescues from StandardError' do
          expect { Alfa.create(a_string: bad_string) }.to raise_error StandardError
          expect { seeder.seed(1) }.not_to raise_error
        end

        it 'cleans and adds error message to the errors list' do
          seeder.seed(10)
          expect(seeder.errors.count).to eq 1
          expect(seeder.errors.first.length).to be <= 200
          expect(seeder.errors.first).not_to include("\n")
        end
      end
    end
  end
end
