# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record attribute
  class Attribute
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :column

    attr_reader :model, :column

    TYPE_SYMMETRIES = {
      binary: :integer,
      datetime: :time,
      decimal: :float,
      text: :string
    }.freeze
    private_constant :TYPE_SYMMETRIES

    # Initializes an instance
    # @param model [DirtySeed::Model]
    # @param column [ActiveRecord::ConnectionAdapters::Column]
    # @return [DirtySeed::Attribute]
    def initialize(model, column)
      @model = model
      @column = column
    end

    # Returns a value matching type and validators
    # @return [Object, nil]
    def value
      assigner.value
    end

    # Returns the attribute assigner
    # @return [DirtySeed::Assigners::Assigner]
    def assigner
      @assigner ||= DirtySeed::Assigners::Base.new(self)
    end

    # Returns attribute name
    # @return [Symbol]
    def name
      @name ||= column.name.to_sym
    end

    # Returns attribute type
    # @return [Symbol]
    def type
      @type ||=
        TYPE_SYMMETRIES[column.sql_type_metadata.type] || column.sql_type_metadata.type
    end

    # Returns an validators related to the current attribute
    # @return [Array<ActiveModel::Validations::EachValidators>]
    def validators
      @validators ||=
        model.validators.select do |validator|
          validator.attributes.include? name
        end
    end
  end
end
