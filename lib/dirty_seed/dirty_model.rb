# frozen_string_literal: true

module DirtySeed
  # represents an Active Record model
  class DirtyModel
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :model

    attr_reader :model, :sequence, :seeded
    attr_writer :errors

    # initializes an instance with:
    # - model: a class inheriting from ApplicationRecord
    def initialize(model: nil)
      self.model = model
    end

    # validates and sets @model
    def model=(value)
      raise ArgumentError, ':model should inherits from ApplicationRecord' unless value&.<(::ApplicationRecord)

      @model = value
    end

    # returns an Array of ActiveRecord models
    # where models are associated to the current model
    # through a has_many or has_one associations
    def associated_models
      associations.map(&:associated_models).flatten
    end

    # returns an Array of DirtyAssociations
    # representing the self.model belongs_to associations
    def associations
      included_reflections.map do |reflection|
        DirtySeed::DirtyAssociation.new(dirty_model: self, reflection: reflection)
      end
    end

    # returns a Array of Strings representing the self.model attributes
    def attributes
      included_columns.map do |column|
        DirtySeed::DirtyAttribute.new(dirty_model: self, column: column)
      end
    end

    # returns uniq errors
    def errors
      @errors.flatten.uniq
    end

    # creates instances for each model
    def seed(count = 5)
      reset_info
      count.times do |sequence|
        @sequence = sequence
        create_instance
      end
    end

    private

    # reset seed info
    def reset_info
      @seeded = 0
      @errors = []
    end

    # creates an instance
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

    # returns an ActiveRecord::ConnectionAdapters::Columns array
    # that should be treated as regular attributes
    def included_columns
      excluded = excluded_attributes + reflection_related_attributes
      model.columns.reject do |column|
        column.name.in? excluded
      end
    end

    # returns a strings array of default excluded attributes
    def excluded_attributes
      %w[id created_at updated_at]
    end

    # returns a strings array of attributes related to an association
    # e.g. foo_id, doable_id, doable_type...
    def reflection_related_attributes
      all_reflection_related_attributes =
        associations.map do |association|
          [association.attribute, association.type_key].compact
        end
      all_reflection_related_attributes.flatten.map(&:to_s)
    end

    # returns an ActiveRecord::Reflection::BelongsToReflections array
    # of the self.model belongs_to reflections
    def included_reflections
      model.reflections.values.select do |reflection|
        reflection.is_a? ActiveRecord::Reflection::BelongsToReflection
      end
    end
  end
end
