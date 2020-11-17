# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record association
  class DirtyAssociation
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :reflections

    attr_reader :dirty_model, :reflection
    alias model dirty_model

    # Initializes an instance
    # @param dirty_model [DirtySeed::DirtyModel]
    # @param reflection [ActiveRecord::Reflection::BelongsToReflection]
    # @return [DirtySeed::DirtyAssociation]
    def initialize(dirty_model: nil, reflection: nil)
      self.dirty_model = dirty_model
      self.reflection = reflection
    end

    # Validates and sets @dirty_model
    # @param value [DirtySeed::DirtyModel]
    # @return [DirtySeed::DirtyModel]
    # @raise [ArgumentError] if value is not valid
    def dirty_model=(value)
      raise ArgumentError unless value.nil? || value.is_a?(DirtySeed::DirtyModel)

      @dirty_model = value
    end

    # Validates and sets @reflection
    # @param value [ActiveRecord::Reflection::BelongsToReflection]
    # @return [ActiveRecord::Reflection::BelongsToReflection]
    # @raise [ArgumentError] if value is not valid
    def reflection=(value)
      raise ArgumentError unless value.nil? || value.is_a?(ActiveRecord::Reflection::BelongsToReflection)

      @reflection = value
    end

    # Assigns a random value to the association
    # @param instance [Object] an instance of a class inheriting from ApplicationRecord
    # @return [void]
    def assign_value(instance)
      return if associated_models.empty?

      instance.public_send(:"#{name}=", value)
    rescue ArgumentError => e
      @errors << e
    end

    # Returns a random instance matching the reflection
    # @return [Object] an instance of a class inheriting from ApplicationRecord
    def value
      random_model = associated_models.sample
      random_id = random_model.pluck(:id).sample
      random_model.find_by(id: random_id)
    end

    # Returns the reflection name
    # @return [String]
    def name
      reflection.name
    end

    # Returns the attribute containing the foreign key
    # @return [Symbol]
    def attribute
      :"#{name}_id"
    end

    # Returns the attribute containing the foreign type (for polymorphic associations)
    # @example
    #   Given Bar.belongs_to(:barable, polymorphic: true)
    #   And self.model == Bar
    #   Then it returns barable_type
    # @return [Symbol]
    def type_key
      reflection.foreign_type&.to_sym
    end

    # Returns or defines associated_models
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def associated_models
      polymorphic? ? polymorphic_associations : regular_associations
    end

    # Returns true if the reflection is polymorphic
    # @example
    #   Given Bar.belongs_to(:barable, polymorphic: true)
    #   And self.model == Bar
    #   Then it returns true
    # @return [Boolean]
    def polymorphic?
      reflection.options[:polymorphic]
    end

    private

    # Returns the reflected models for a regular association
    # @example
    #   Given Bar.belongs_to(:foo)
    #   And Foo.has_many(:bars)
    #   And self.model == Bar
    #   Then it returns [Foo]
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def regular_associations
      [reflection.klass]
    end

    # Returns the reflected models for a polymorphic association
    # @example
    #   Given Bar.belongs_to(:barable, polymorphic: true)
    #   And Foo.has_many(:bars, as: :barable)
    #   And Zed.has_many(:bars, as: :barable)
    #   And #model is Bar
    #   Then it returns [Foo, Zed]
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def polymorphic_associations
      DirtySeed::DataModel.active_record_models.select do |active_record_model|
        active_record_model.reflections.values.any? do |arm_reflection|
          arm_reflection.options[:as]&.to_sym == name
        end
      end
    end
  end
end
