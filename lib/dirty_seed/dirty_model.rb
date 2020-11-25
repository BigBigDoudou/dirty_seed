# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record model
  class DirtyModel
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :model

    attr_reader :model, :instances, :seeded
    attr_writer :errors

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
    # @return [DirtySeed::DirtyModel]
    def initialize(model)
      @model = model
      @instances = []
      @seeded = 0
      @errors = []
    end

    # Creates instances for each model
    # @param count [Integer]
    # @return [void]
    def seed(count)
      count.times { create_instance }
      @instances
    end

    # Returns models where models are associated to the current model through a has_many or has_one associations
    # @return [Array<Class>] ActiveRecord models
    def associated_models
      dirty_associations.map(&:associated_models).flatten
    end

    # Returns an dirty associations representing the self.model belongs_to associations
    # @return [Array<DirtySeed::DirtyAssociation>]
    def dirty_associations
      included_reflections.map do |reflection|
        DirtySeed::DirtyAssociation.new(self, reflection)
      end
    end

    # Returns model attributes
    # @return [Array<DirtySeed::DirtyAttribute>]
    def dirty_attributes
      included_columns.map do |column|
        DirtySeed::DirtyAttribute.new(self, column)
      end
    end

    # Returns uniq errors
    # @return [Array<Error>]
    def errors
      @errors.flatten.uniq
    end

    private

    # Creates an instance
    # @return [void]
    def create_instance
      @instances << instance = model.new
      dirty_associations.each { |dirty_association| dirty_association.assign_value(instance) }
      dirty_attributes.each { |dirty_attribute| dirty_attribute.assign_value(instance) }
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
        dirty_associations.map do |dirty_association|
          [dirty_association.attribute, dirty_association.type_key].compact
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
