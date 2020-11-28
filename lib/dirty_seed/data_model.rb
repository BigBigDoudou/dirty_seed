# frozen_string_literal: true

module DirtySeed
  # Represents the data model
  class DataModel
    include Singleton

    attr_writer :seeders, :models

    # Initializes an instance
    # @return [DirtySeed::DataModel]
    def initialize
      Rails.application.eager_load!
    end

    # Returns the logger
    # @return [DirtySeed::Logger]
    def logger
      DirtySeed::Logger.instance
    end

    # Seeds the database with dirty instances
    # @param count [Integer] count of record to seed for each model
    # @param verbose [Boolean] true if logs should be outputed
    # @return [void]
    def seed(count, verbose: false)
      logger.verbose = verbose
      # check if ApplicationRecord is defined first (or raise error)
      ::ApplicationRecord && seeders.each { |seeder| seeder.seed(count) }
      logger.summary(seeders)
    end

    # Creates and returns a seeder for each model
    # @return [Array<SirtySeed::Seeder>]
    def seeders
      @seeders ||= models.map { |model| DirtySeed::Seeder.new(model) }
    end

    # Creates and returns dirty models
    # @return [Array<DirtySeed::Model>]
    def models
      @models ||= DirtySeed::Sorter.new(unsorted_models).sort
    end

    # Returns ApplicationRecord inherited classes sorted by their associations
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def unsorted_models
      active_record_models.map { |active_record_model| DirtySeed::Model.new(active_record_model) }
    end

    # Returns an ApplicationRecord inherited classes
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def active_record_models
      ::ApplicationRecord.descendants.reject(&:abstract_class)
    end
  end
end
