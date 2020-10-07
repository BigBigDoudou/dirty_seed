# frozen_string_literal: true

namespace :dirty_seed do
  desc 'Explaining what the task does'
  task seed: :environment do
    DirtySeed::DataModel.seed
  end
end
