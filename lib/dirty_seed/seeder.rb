# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record model
  class Seeder
    attr_reader :model, :records, :errors

    # Initializes an record
    # @param model [DirtySeed::Model]
    # @return [DirtySeed::Seeder]
    def initialize(model)
      @model = model
      @records = []
      @errors = []
    end

    # Creates records
    # @param count [Integer]
    # @return [Array<Object>]
    def seed(qty = 1)
      self.quantity = qty
      logger.seed_model_message(model)
      create_records
      records
    end

    private

    attr_accessor :successive_errors, :quantity
    attr_writer :errors

    # Returns the logger
    # @return [DirtySeed::Logger]
    def logger
      DirtySeed::Logger.instance
    end

    # Creates records
    # @return [void]
    # @note To take advantage of the faker uniqueness system, all params needs to be defined
    #   Then all records can be created with these params
    #   In other words: do not justcreate record one after the other
    def create_records
      self.successive_errors = 0
      params_collection.each do |params|
        break if exceeded_successive_errors?

        record = initialize_record(params)
        record && save(record)
      end
    end

    # Is the successive errors maximum reached?
    # @return [Boolean]
    # @note The purpose is to stop trying to seed if to many errors happen
    def exceeded_successive_errors?
      return false if successive_errors < 3

      logger.abort
      true
    end

    # Initialize a record
    # @param params [Hash] params to pass to #new
    # @return [Object] instance of model
    def initialize_record(params)
      model.new(params)
      # rescue from errors on initialize
    rescue StandardError => e
      add_standard_error(e)
    end

    # Tries to save record in database
    #   Populates records and errors and log message
    # @return [void]
    def save(record)
      if record.save
        records << record
        self.successive_errors = 0
        logger.success
      else
        add_record_errors(record)
      end
    # rescue from errors on save
    rescue StandardError => e
      add_standard_error(e)
    end

    # Adds record errors
    # @param record [Object] instance of model
    # @return [void]
    def add_record_errors(record)
      self.errors |= record.errors.full_messages
      self.successive_errors = successive_errors + 1
      logger.failure
    end

    # Adds standard error
    # @param error [Error] error inheriting from StandardError
    # @return [void]
    def add_standard_error(error)
      self.errors |= [logger.clean(error.message)]
      self.successive_errors = successive_errors + 1
      logger.failure
    end

    # Generate records params
    # @return [Array<Hash>] where Hash is params for one record
    # @note If model has no attributes and no associations, return empty hashes
    def params_collection
      data = Hash[attributes_collection + associations_collection]
      data = data.values.transpose.map { |vs| data.keys.zip(vs).to_h }
      data.any? ? data : Array.new(quantity, {})
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
        [attribute.name, Array.new(quantity) { attribute.value }]
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
        [association.name, Array.new(quantity) { association.value }]
      end
    end
  end
end
