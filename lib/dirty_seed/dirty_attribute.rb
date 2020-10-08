# frozen_string_literal: true

module DirtySeed
  # represents an Active Record attribute
  class DirtyAttribute
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :column

    attr_reader :dirty_model, :column
    alias model dirty_model

    # initializes an instance with:
    # - dirty_model: instance of DirtySeed::DirtyModel
    # - column: ActiveRecord::ConnectionAdapters::Column
    def initialize(dirty_model:, column:)
      @dirty_model = dirty_model
      @column = column
      validate_arguments!
    end

    # assigns an value to the attribute
    def assign_value(instance)
      # type is automatically set by Model.new
      return if type == :sti_type

      instance.assign_attributes(name => value)
    rescue ArgumentError => e
      model.errors << e
    end

    # returns a value matching type and validators
    def value
      case type
      when :boolean then dirty_boolean
      when :integer then dirty_integer
      when :float then dirty_float
      when :string then dirty_string
      end
    end

    # returns attribute name
    def name
      column.name.to_sym
    end

    # returns attribute type
    def type
      return :sti_type if column.name == 'type'
      return :float if column.name == 'decimal'

      column.sql_type_metadata.type
    end

    private

    # returns a Boolean matching the validators
    def dirty_boolean
      Assigners::DirtyBoolean.new(validators: validators).value
    end

    # returns an Integer matching the validators
    def dirty_integer
      Assigners::DirtyInteger.new(validators: validators, sequence: model.sequence).value
    end

    # returns a Float matching the validators
    def dirty_float
      Assigners::DirtyFloat.new(validators: validators, sequence: model.sequence).value
    end

    # returns a String matching the validators
    def dirty_string
      Assigners::DirtyString.new(validators: validators, sequence: model.sequence).value
    end

    # returns an Array of ActiveModel::Validations::EachValidators
    # related to the current attribute
    def validators
      model.validators.select do |validator|
        validator.attributes.include? name
      end
    end

    # validates that arguments match expected types
    def validate_arguments!
      dirty_model.is_a?(DirtySeed::DirtyModel) ||
        raise(ArgumentError, ':dirty_model should be a DirtySeed::DirtyModel instance')
      column.is_a?(ActiveRecord::ConnectionAdapters::Column) ||
        raise(ArgumentError, ':column should be an ActiveRecord::ConnectionAdapters::Column instance')
    end
  end
end
