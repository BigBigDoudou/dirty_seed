# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record model
  class Seeder
    attr_reader :model, :instances, :errors

    # Initializes an instance
    # @param model [DirtySeed::Model]
    # @return [DirtySeed::Seeder]
    def initialize(model)
      @model = model
      @instances = []
      @errors = []
    end

    # Creates records
    # @param count [Integer]
    # @return [Array<Object>]
    def seed(count)
      logger.seed(model)
      @count = count
      create_records
      @errors.uniq!
      instances
    end

    # Returns the number of successfully seeded records
    # @return [Integer]
    def score
      instances.count
    end

    # Returns the errors as list
    # @return [String]
    def error_list
      errors.join(', ')
    end

    private

    # Returns the logger
    # @return [DirtySeed::Logger]
    def logger
      DirtySeed::Logger.instance
    end

    # Creates records
    # @return [void]
    def create_records
      logger.start_line
      data = params_collection
      @count.times do |i|
        instance = model.new(data[i])
        save(instance)
      # rescue from errors on initialize
      rescue StandardError => e
        @errors << e.message
        logger.error
      end
      logger.break_line
    end

    # Tries to save instance in database
    #   Populates instances and errors and log message
    # @return [void]
    def save(instance)
      if instance.save
        logger.success
        @instances << instance
      else
        logger.fail
        @errors.concat(instance.errors.full_messages)
      end
    # rescue from errors on save
    rescue StandardError => e
      @errors << e.message
      logger.error
    end

    # Generate records params
    # @return [Array<Hash>] where Hash is params for one record
    def params_collection
      data = Hash[attributes_collection + associations_collection]
      data.values.transpose.map { |vs| data.keys.zip(vs).to_h }
    end

    # Generate attributes params
    #   Each sub-array contains the attribute name and a collection of values
    # @return [Array<Array>]
    # @example
    #   [
    #     ["a_string", ["foo", "bar"]],
    #     [an_integer, [1, 2]]
    #   ]
    def attributes_collection
      model.attributes.map do |attribute|
        Faker::UniqueGenerator.clear
        [attribute.name, Array.new(@count) { attribute.value }]
      end
    end

    # Generate associations params
    #   Each sub-array contains the association name and a collection of values
    # @return [Array<Array>]
    # @example
    #   [
    #     ["alfa", [#<Alfa>, #<Alfa>]],
    #     ["bravo", [#<Bravo>, #<Bravo>]]
    #   ]
    def associations_collection
      model.associations.map do |association|
        [association.name, Array.new(@count) { association.value }]
      end
    end
  end
end
