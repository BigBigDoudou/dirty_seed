# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

RSpec.describe 'Dirty Seed' do
  describe 'dirty_seed:seed' do
    before(:each) { Rake::Task[:'dirty_seed:seed'].invoke }

    it 'should seed data' do
      active_record_models = [Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India]
      expect(
        active_record_models.map(&:count).all?(&:positive?)
      ).to be true
    end
  end
end
