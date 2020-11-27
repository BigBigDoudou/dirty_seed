# frozen_string_literal: true

module DirtySeed
  # Represents an Active Record association
  class Association < SimpleDelegator
    # @!method initialize(reflection)
    # @param reflection [ActiveRecord::Reflection::BelongsToReflection]
    # @return [DirtySeed::Association]

    # Returns a random instance matching the reflection
    # @return [Object, nil] an instance of a class inheriting from ApplicationRecord
    def value
      return if associated_models.empty?

      random_model = associated_models.sample
      random_id = random_model.pluck(:id).sample
      random_model.find_by(id: random_id)
    end

    # Returns the attribute containing the foreign key
    # @return [Symbol]
    def attribute
      :"#{name}_id"
    end

    # Returns the attribute containing the foreign type (for polymorphic associations)
    # @return [Symbol]
    # @example
    #   Given Bar.belongs_to(:barable, polymorphic: true)
    #   And self.model == Bar
    #   Then it returns barable_type
    def type_key
      foreign_type&.to_sym
    end

    # Returns or defines associated_models
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def associated_models
      polymorphic? ? polymorphic_associations : regular_associations
    end

    # Is the association optional?
    # @return [Boolean]
    # @example
    #   Given Bar.belongs_to(:barable, optional: true)
    #   And self.model == Bar
    #   Then it returns true
    def optional?
      options[:optional].present?
    end

    # Is the reflection polymorphic?
    # @return [Boolean]
    # @example
    #   Given Bar.belongs_to(:barable, polymorphic: true)
    #   And self.model == Bar
    #   Then it returns true
    def polymorphic?
      options[:polymorphic].present?
    end

    private

    # Returns the reflected models for a regular association
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    # @example
    #   Given Bar.belongs_to(:foo)
    #   And Foo.has_many(:bars)
    #   And self.model == Bar
    #   Then it returns [Foo]
    def regular_associations
      [klass]
    rescue NameError
      []
    end

    # Returns the reflected models for a polymorphic association
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    # @example
    #   Given Bar.belongs_to(:barable, polymorphic: true)
    #   And Foo.has_many(:bars, as: :barable)
    #   And Zed.has_many(:bars, as: :barable)
    #   And #model is Bar
    #   Then it returns [Foo, Zed]
    def polymorphic_associations
      DirtySeed::DataModel.instance.active_record_models.select do |active_record_model|
        active_record_model.reflections.values.any? do |arm_reflection|
          arm_reflection.options[:as]&.to_sym == name
        end
      end
    rescue NameError
      []
    end
  end
end
