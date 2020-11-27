# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record attribute
  class Attribute < SimpleDelegator
    # @!method initialize(column)
    # @param column [ActiveRecord::ConnectionAdapters::Column]
    # @return [DirtySeed::Attribute]

    attr_accessor :model
    attr_writer :validators, :enum

    delegate :value, to: :assigner

    TYPE_SYMMETRY = {
      binary: :integer,
      datetime: :time,
      decimal: :float,
      jsonb: :json,
      text: :string
    }.freeze
    private_constant :TYPE_SYMMETRY

    # Returns the attribute assigner
    # @return [DirtySeed::Assigners::Assigner]
    def assigner
      @assigner ||= DirtySeed::Assigners::Dispatcher.new(self)
    end

    # Returns attribute type
    # @return [Symbol]
    def type
      sql_type = sql_type_metadata.type.to_s.gsub('[]', '').to_sym
      @type ||= TYPE_SYMMETRY[sql_type] || sql_type
    end

    # Is attribute an array?
    # @return [Boolean]
    # @note When attribute is serialized as array, it raises an error
    #   if value is not an array -> use this to define if it is an array
    def array?
      return true if sql_type_metadata.type.to_s.include? '[]'

      model&.new(name => '')
      # it does not raise error -> it is not a serialized array
      false
    rescue ActiveRecord::SerializationTypeMismatch
      # it raises an error -> it is (certainly) a serialized array
      true
    end

    # Returns validators
    # @return [Array<Object>] array of validators
    def validators
      @validators ||=
        model&.validators&.select do |validator|
          validator.attributes.include? name.to_sym
        end
    end

    # Returns enum
    # @return [Array<Object>] array of options
    def enum
      @enum ||= model&.defined_enums&.dig(name)
    end
  end
end
