# frozen_string_literal: true

module DirtySeed
  class Engine < ::Rails::Engine
    isolate_namespace DirtySeed

    config.generators do |generators|
      generators.test_framework :rspec
    end
  end
end
