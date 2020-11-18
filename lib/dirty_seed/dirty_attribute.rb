# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record attribute
  class DirtyAttribute
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :column

    attr_reader :dirty_model, :column

    # Initializes an instance
    # @param dirty_model [DirtySeed::DirtyModel]
    # @param column [ActiveRecord::ConnectionAdapters::Column]
    # @return [DirtySeed::DirtyAttribute]
    def initialize(dirty_model, column)
      @dirty_model = dirty_model
      @column = column
    end

    # Assigns a value to the attribute
    # @param instance [Object] an instance of a class inheriting from ApplicationRecord
    # @param sequence [Integer]
    # @return [void]
    def assign_value(instance, sequence)
      instance.assign_attributes(name => value(sequence))
    rescue ArgumentError => e
      dirty_model.errors << e
    end

    # Returns a value matching type and validators
    # @param sequence [Integer]
    # @return [Object, nil]
    def value(sequence)
      assigner = "DirtySeed::Assigners::Dirty#{type.capitalize}".constantize
      assigner.new(self, sequence).value
    # If attribute type is not currently handled (json, array...) return nil
    rescue NameError
      nil
    end

    # Returns attribute name
    # @return [Symbol]
    def name
      column.name.to_sym
    end

    # Returns attribute type
    # @return [Symbol]
    def type
      return :float if column.sql_type_metadata.type == :decimal
      return :time if column.sql_type_metadata.type == :datetime

      column.sql_type_metadata.type
    end

    # Returns an validators related to the current attribute
    # @return [Array<ActiveModel::Validations::EachValidators>]
    def validators
      dirty_model.validators.select do |validator|
        validator.attributes.include? name
      end
    end
  end
end
