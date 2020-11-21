# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

RSpec.describe 'Dirty Seed' do
  describe 'dirty_seed:seed' do
    before(:each) do
      # prevent logs in specs
      allow_any_instance_of(DirtySeed::DataModel).to(receive(:print_logs).and_return(nil))
      ENV['COUNT'] = '8'
      Rake::Task[:'dirty_seed:seed'].invoke
    end

    it 'seeds data' do
      # As expected, Juliett can not be seed
      regular_models = [Alfa, Bravo, Charlie, Delta, Echo, Golf, Hotel, India, Kilo]
      expect(regular_models.map(&:count).all? { |c| c == 8 }).to be true
      # 8 Foxtrot + 8 inherited Golf model
      expect(Foxtrot.count).to eq 16
      # unseedable
      expect(Juliett.none?).to be true
    end
  end
end
