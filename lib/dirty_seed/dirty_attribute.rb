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
    def initialize(dirty_model: nil, column: nil)
      self.dirty_model = dirty_model
      self.column = column
    end

    # validates and sets @dirty_model
    def dirty_model=(value)
      raise ArgumentError unless value.nil? || value.is_a?(DirtySeed::DirtyModel)

      @dirty_model = value
    end

    # validates and sets @column
    def column=(value)
      raise ArgumentError unless value.nil? || value.is_a?(ActiveRecord::ConnectionAdapters::Column)

      @column = value
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
      __send__(:"dirty_#{type}")
    end

    # returns attribute name
    def name
      column.name.to_sym
    end

    # returns attribute type
    def type
      return :sti_type if column.name == 'type'
      return :float if column.name == 'decimal'
      return :time if column.name == 'datetime'

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

    # returns a Date matching the validators
    def dirty_date
      Assigners::DirtyDate.new(validators: validators, sequence: model.sequence).value
    end

    # returns a Time matching the validators
    def dirty_time
      Assigners::DirtyTime.new(validators: validators, sequence: model.sequence).value
    end

    # returns an Array of ActiveModel::Validations::EachValidators
    # related to the current attribute
    def validators
      model.validators.select do |validator|
        validator.attributes.include? name
      end
    end
  end
end
