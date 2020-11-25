# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record model
  class Model
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :model

    attr_reader :model, :instances, :errors

    PROTECTED_COLUMNS = %w[
      id
      type
      created_at
      updated_at
      encrypted_password
      reset_password_token
      reset_password_sent_at
      remember_created_at
    ].freeze
    public_constant :PROTECTED_COLUMNS

    # Initializes an instance
    # @param model [Class] a class inheriting from ApplicationRecord
    # @return [DirtySeed::Model]
    def initialize(model)
      @model = model
      @instances = []
      @errors = []
    end

    # Creates records
    # @param count [Integer]
    # @return [Array<Object>]
    def seed(count)
      puts "Seeding #{name.underscore.pluralize}"
      @count = count
      create_records
    rescue ActiveRecord::ActiveRecordError => e
      @errors << e
    ensure
      instances
    end

    # Creates records
    # @return [void]
    def create_records
      data = params_collection
      @count.times do |i|
        instance = model.new(data[i])
        save(instance)
      end
      puts ''
    end

    # Tries to save instance in database
    #   Populates instances and errors and log message
    # @return [void]
    def save(instance)
      if instance.save
        print '.'
        @instances << instance
      else
        print '!'
        @errors << instance.errors.full_messages
      end
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
      attributes.map do |attribute|
        Faker::UniqueGenerator.clear
        [attribute.name, @count.times.map { attribute.value }]
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
      associations.map do |association|
        [association.name, @count.times.map { association.value }]
      end
    end

    # Returns models where models are associated to the current model through a has_many or has_one associations
    # @return [Array<Class>] ActiveRecord models
    def associated_models
      associations.map(&:associated_models).flatten
    end

    # Returns an dirty associations representing the self.model belongs_to associations
    # @return [Array<DirtySeed::Association>]
    def associations
      included_reflections.map do |reflection|
        DirtySeed::Association.new(self, reflection)
      end
    end

    # Returns model attributes
    # @return [Array<DirtySeed::Attribute>]
    def attributes
      included_columns.map do |column|
        DirtySeed::Attribute.new(self, column)
      end
    end

    # Returns uniq errors
    # @return [Array<Error>]
    def errors
      @errors.flatten.uniq
    end

    private

    # Returns columns that should be treated as regular attributes
    # @return [Array<ActiveRecord::ConnectionAdapters::Column>]
    def included_columns
      excluded = PROTECTED_COLUMNS + reflection_related_attributes
      model.columns.reject do |column|
        column.name.in? excluded
      end
    end

    # Returns attributes related to an association
    # @example
    #   ["foo_id", "doable_id", "doable_type"]
    # @return [Array<String>]
    def reflection_related_attributes
      all_reflection_related_attributes =
        associations.map do |association|
          [association.attribute, association.type_key].compact
        end
      all_reflection_related_attributes.flatten.map(&:to_s)
    end

    # Returns reflections of the model
    # @return [Array<ActiveRecord::Reflection::BelongsToReflection>]
    def included_reflections
      model.reflections.values.select do |reflection|
        reflection.is_a? ActiveRecord::Reflection::BelongsToReflection
      end
    end
  end
end
