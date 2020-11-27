# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'lib/dirty_seed/version.rb'
end

ENV['RAILS_ENV'] ||= 'test'

ENGINE_ROOT = File.join(File.dirname(__FILE__), '../')

# Load environment.rb from the dummy app.
require File.expand_path('dummy/config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'database_cleaner'
require 'factory_bot_rails'
require 'rspec/rails'
Dir[Rails.root.join('../../spec/support/**/*.rb')].sort.each { |f| require f }

# Load migrations from the dummy app.
ActiveRecord::Migrator.migrations_paths = File.join(ENGINE_ROOT, 'spec/dummy/db/migrate')
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around do |example|
    DirtySeed::DataModel.instance.models = nil
    DirtySeed::DataModel.instance.seeders = nil
    Faker::UniqueGenerator.clear
    DirtySeed::Engine.initializers.each(&:run)
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
