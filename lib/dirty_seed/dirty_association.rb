# frozen_string_literal: true

module DirtySeed
  # represents an Active Record association
  class DirtyAssociation
    extend ::DirtySeed::MethodMissingHelper
    forward_missing_methods_to :reflections

    attr_reader :dirty_model, :reflection
    alias model dirty_model

    # initializes an instance with:
    # - dirty_model: instance of DirtySeed::DirtyModel
    # - reflection: instance of ActiveRecord::Reflection::BelongsToReflection
    def initialize(dirty_model: nil, reflection: nil)
      self.dirty_model = dirty_model
      self.reflection = reflection
    end

    # validates and sets @dirty_model
    def dirty_model=(value)
      raise ArgumentError unless value.nil? || value.is_a?(DirtySeed::DirtyModel)

      @dirty_model = value
    end

    # validates and sets @reflection
    def reflection=(value)
      raise ArgumentError unless value.nil? || value.is_a?(ActiveRecord::Reflection::BelongsToReflection)

      @reflection = value
    end

    # assigns a random instance to the association
    def assign_value(instance)
      return if associated_models.empty?

      instance.public_send(:"#{name}=", value)
    rescue ArgumentError => e
      @errors << e
    end

    # returns a random instance matching the reflection
    def value
      random_model = associated_models.sample
      random_id = random_model.pluck(:id).sample
      random_model.find(random_id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    # returns as String the reflection name
    # e.g. foo
    def name
      reflection.name
    end

    # returns as Symbol the attribute containing the foreign key
    # e.g. foo_id
    def attribute
      :"#{name}_id"
    end

    # returns as Symbol the attribute containing the foreign type (for polymorphic associations)
    #
    # given Bar.belongs_to(:barable, polymorphic: true)
    # and self.model == Bar
    # then it returns barable_type
    def type_key
      reflection.foreign_type&.to_sym
    end

    # returns @associated_models or defines it depending on the association type
    def associated_models
      !polymorphic? ? regular_associations : polymorphic_associations
    end

    # returns true if the reflection is polymorphic
    #
    # given Bar.belongs_to(:barable, polymorphic: true)
    # and self.model == Bar
    # then it returns true
    def polymorphic?
      reflection.options[:polymorphic]
    end

    private

    # returns an Array containing the reflected model
    #
    # given Bar.belongs_to(:foo)
    # and Foo.has_many(:bars)
    # and self.model == Bar
    # then it returns [Foo]
    def regular_associations
      [reflection.klass]
    end

    # returns an Array containing all reflected models
    #
    # given Bar.belongs_to(:barable, polymorphic: true)
    # and Foo.has_many(:bars, as: :barable)
    # and Zed.has_many(:bars, as: :barable)
    # and #model is Bar
    # then it returns [Foo, Zed]
    def polymorphic_associations
      DirtySeed::DataModel.active_record_models.select do |active_record_model|
        active_record_model.reflections.values.any? do |arm_reflection|
          arm_reflection.options[:as]&.to_sym == name
        end
      end
    end
  end
end
