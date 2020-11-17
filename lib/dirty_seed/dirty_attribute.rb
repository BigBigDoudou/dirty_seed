# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record attribute
  class DirtyAttribute
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :column

    attr_reader :dirty_model, :column
    alias model dirty_model

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
      __send__(:"dirty_#{type}") if self.class.private_instance_methods(false).include? :"dirty_#{type}"
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

    private

    # Returns a boolean matching the validators
    # @return [Boolean]
    def dirty_boolean
      Assigners::DirtyBoolean.new(validators: validators).value
    end

    # Returns an integer matching the validators
    # @return [Integer]
    def dirty_integer
      Assigners::DirtyInteger.new(validators: validators, sequence: model.sequence).value
    end

    # Returns a float matching the validators
    # @return [Float]
    def dirty_float
      Assigners::DirtyFloat.new(validators: validators, sequence: model.sequence).value
    end

    # Returns a string matching the validators
    # @return [String]
    def dirty_string
      Assigners::DirtyString.new(validators: validators, sequence: model.sequence).value
    end

    # Returns a date matching the validators
    # @return [Date]
    def dirty_date
      Assigners::DirtyDate.new(validators: validators, sequence: model.sequence).value
    end

    # Returns a time matching the validators
    # @return [Time]
    def dirty_time
      Assigners::DirtyTime.new(validators: validators, sequence: model.sequence).value
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
