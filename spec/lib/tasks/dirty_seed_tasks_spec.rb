# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

RSpec.describe 'Dirty Seed' do
  describe 'dirty_seed:seed' do
    before(:each) do
      # prevent logs in specs
      allow_any_instance_of(DirtySeed::DataModel).to(receive(:print_logs).and_return(nil))
      Rake::Task[:'dirty_seed:seed'].invoke
    end

    it 'seeds data' do
      # As expected, Juliett can not be seed
      active_record_models = [Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Kilo]
      expect(active_record_models.map(&:count).all?(&:positive?)).to be true
    end
  end
end
