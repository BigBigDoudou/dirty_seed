# frozen_string_literal: true

namespace :dirty_seed do
  desc 'Explaining what the task does'
  task seed: :environment do
    count = ENV['COUNT']&.to_i || 10
    DirtySeed::DataModel.seed(count)
  end
end
