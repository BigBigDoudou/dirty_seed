# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record model
  class Model < SimpleDelegator
    # @!method initialize(active_record_model)
    # @param active_record_model [Class] an active record model
    # @return [DirtySeed::Model]

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

    # Returns ActiveRecord models associated to the current ActiveRecord model
    #   through a has_many or has_one associations
    # @return [Array<Class>] ActiveRecord models
    def associated_models
      associations.map(&:associated_models).flatten
    end

    # Returns an dirty associations representing the ActiveRecord model belongs_to associations
    # @return [Array<DirtySeed::Association>]
    def associations
      included_reflections.map do |reflection|
        DirtySeed::Association.new(reflection)
      end
    end

    # Returns ActiveRecord model attributes
    # @return [Array<DirtySeed::Attribute>]
    def attributes
      included_columns.map do |column|
        attribute = DirtySeed::Attribute.new(column)
        attribute.model = self
        attribute
      end
    end

    private

    # Returns columns that should be treated as regular attributes
    # @return [Array<ActiveRecord::ConnectionAdapters::Column>]
    def included_columns
      excluded = PROTECTED_COLUMNS + reflection_related_attributes
      columns.reject do |column|
        column.name.in? excluded
      end
    end

    # Returns attributes related to an association
    # @return [Array<String>]
    # @example
    #   ["foo_id", "doable_id", "doable_type"]
    def reflection_related_attributes
      all_reflection_related_attributes =
        associations.map do |association|
          [association.attribute, association.type_key].compact
        end
      all_reflection_related_attributes.flatten.map(&:to_s)
    end

    # Returns reflections of the ActiveRecord model
    # @return [Array<ActiveRecord::Reflection::BelongsToReflection>]
    def included_reflections
      reflections.values.select do |reflection|
        reflection.is_a? ActiveRecord::Reflection::BelongsToReflection
      end
    end
  end
end
