# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record model
  class DirtyModel
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :model

    attr_reader :model, :sequence, :seeded
    attr_writer :errors

    # Initializes an instance
    # @param model [Class] a class inheriting from ApplicationRecord
    # @return [DirtySeed::DirtyModel]
    def initialize(model: nil)
      self.model = model
    end

    # Validates and sets @model
    # @param value [Class, nil] a class inheriting from ApplicationRecord
    # @return [Class] a class inheriting from ApplicationRecord
    # @raise [ArgumentError] if value is not valid
    def model=(value)
      raise ArgumentError unless value.nil? || (value < ::ApplicationRecord)

      @model = value
    end

    # Returns models where models are associated to the current model through a has_many or has_one associations
    # @return [Array<Class>] ActiveRecord models
    def associated_models
      associations.map(&:associated_models).flatten
    end

    # Returns an dirty associations representing the self.model belongs_to associations
    # @return [Array<DirtySeed::DirtyAssociation>]
    def associations
      included_reflections.map do |reflection|
        DirtySeed::DirtyAssociation.new(dirty_model: self, reflection: reflection)
      end
    end

    # Returns model attributes
    # @return [Array<String>]
    def attributes
      included_columns.map do |column|
        DirtySeed::DirtyAttribute.new(dirty_model: self, column: column)
      end
    end

    # Returns uniq errors
    # @return [Array<Error>]
    def errors
      @errors.flatten.uniq
    end

    # Creates instances for each model
    # @param count [Integer]
    # @return [void]
    def seed(count = 5)
      reset_info
      count.times do |sequence|
        @sequence = sequence
        create_instance
      end
    end

    private

    # Reset seed info
    # @return [void]
    def reset_info
      @seeded = 0
      @errors = []
    end

    # Creates an instance
    # @return [void]
    def create_instance
      instance = model.new
      associations.each { |association| association.assign_value(instance) }
      attributes.each { |attribute| attribute.assign_value(instance) }
      if instance.save
        @seeded += 1
      else
        @errors << instance.errors.full_messages
      end
    rescue ActiveRecord::ActiveRecordError => e
      errors << e
    end

    # Returns columns that should be treated as regular attributes
    # @return [Array<ActiveRecord::ConnectionAdapters::Column>]
    def included_columns
      excluded = excluded_attributes + reflection_related_attributes
      model.columns.reject do |column|
        column.name.in? excluded
      end
    end

    # Returns default excluded attributes
    # @return [Array<String>]
    def excluded_attributes
      %w[id created_at updated_at]
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
