# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

RSpec.describe 'dirty_seed:seed' do # rubocop:disable Rspec/DescribeClass
  before do
    ENV['COUNT'] = '8'
    Rake::Task[:'dirty_seed:seed'].invoke
  end

  it 'seeds data' do
    # As expected, Juliett can not be seed
    regulactive_record_models = [Alfa, Bravo, Charlie, Delta, Echo, Golf, Hotel, India]
    expect(regulactive_record_models.map(&:count).all? { |c| c == 8 }).to be true
    # 8 Foxtrot + 8 inherited Golf model
    expect(Foxtrot.count).to eq 16
    # unseedable
    expect(Juliett.none?).to be true
  end
end
