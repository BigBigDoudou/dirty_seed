# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record attribute
  class DirtyAttribute
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :column

    attr_reader :dirty_model, :column
    alias model dirty_model

    delegate :sequence, to: :model

    # Initializes an instance
    # @param dirty_model [DirtySeed::DirtyModel]
    # @param column [ActiveRecord::ConnectionAdapters::Column]
    # @return [DirtySeed::DirtyAttribute]
    def initialize(dirty_model: nil, column: nil)
      self.dirty_model = dirty_model
      self.column = column
    end

    # Validates and sets @dirty_model
    # @param value [DirtySeed::DirtyModel]
    # @return [DirtySeed::DirtyModel]
    # @raise [ArgumentError] if value is not valid
    def dirty_model=(value)
      raise ArgumentError unless value.nil? || value.is_a?(DirtySeed::DirtyModel)

      @dirty_model = value
    end

    # Validates and sets @column
    # @param value [ActiveRecord::ConnectionAdapters::Column]
    # @return [ActiveRecord::ConnectionAdapters::Column]
    # @raise [ArgumentError] if value is not valid
    def column=(value)
      raise ArgumentError unless value.nil? || value.is_a?(ActiveRecord::ConnectionAdapters::Column)

      @column = value
    end

    # Assigns a value to the attribute
    # @return [void]
    def assign_value(instance)
      # type is automatically set by Model.new
      return if type == :sti_type

      instance.assign_attributes(name => value)
    rescue ArgumentError => e
      model.errors << e
    end

    # Returns a value matching type and validators
    # @return [Object]
    def value
      assigner = "DirtySeed::Assigners::Dirty#{type.capitalize}".constantize
      assigner.new(attribute: self).value
    end

    # Returns attribute name
    # @return [Symbol]
    def name
      column.name.to_sym
    end

    # Returns attribute type
    # @return [Symbol]
    def type
      return :sti_type if column.name == 'type'
      return :float if column.sql_type_metadata.type == :decimal
      return :time if column.sql_type_metadata.type == :datetime

      column.sql_type_metadata.type
    end

    # Returns an validators related to the current attribute
    # @return [Array<ActiveModel::Validations::EachValidators>]
    def validators
      model.validators.select do |validator|
        validator.attributes.include? name
      end
    end
  end
end
