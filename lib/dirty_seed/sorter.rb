# frozen_string_literal: true

module DirtySeed
  # sorts ActiveRecord models depending on their associations
  class Sorter
    attr_reader :models, :sorted, :checked, :current, :skip_optional
    alias unsorted models

    # initializes an instance with:
    # - models: array of models inheriting from ActiveRecord::Base
    def initialize(models: [])
      self.models = models
      @sorted = []
      @checked = []
      @current = unsorted.first
    end

    # validates and sets @models
    def models=(value)
      raise ArgumentError unless value.is_a?(Array) && value.all? { |item| item < ::ApplicationRecord }

      @models = value
    end

    # sorts models depending on their associations
    def sort!
      return sorted if unsorted.empty?

      set_current
      # active skip_optional option to prevent infinite loop
      skip_optional! if break_loop?
      insert_or_rotate
      sort!
    end

    private

    # defines the current model to be sorted
    # and add it to the checked ones
    def set_current
      @current = unsorted.first
      checked << current
    end

    # returns true if the current model has already been checked
    # and skip optional option is not already activated
    def break_loop?
      current.in?(checked) && !skip_optional
    end

    # activates skip_optional option to prevent infinite loop
    def skip_optional!
      # if skip_optional is already true
      # there is an infinite loop of belongs_to associations
      raise DirtySeed::CyclicalAssociationsError if skip_optional

      @skip_optional = true
      @checked = []
    end

    # chooses if current should be added to sorted ones or not
    def insert_or_rotate
      # if the current is dependent form a non-sorted model
      if dependent?
        # rotate models array so current will be sorted at the end
        unsorted.rotate!
      else
        # removed current from unsorted and add it to sorted
        sorted << unsorted.shift
      end
    end

    # returns false if there is only one model to sort
    # else returns true if @current belongs_to a model that has not been sorted yet
    def dependent?
      return false if unsorted.one?

      current.reflections.values.any? do |reflection|
        belongs_to?(reflection) &&
          unsorted.any? do |model|
            mirror?(model, reflection)
          end
      end
    end

    # returns true if <relfection> is a :belongs_to kind
    # reflection: ActiveRecord::Reflection::AssociationReflection
    def belongs_to?(reflection)
      return false if reflection.options[:optional] && skip_optional

      reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)
    end

    # returns true if <model> is or can be the <reflection> mirror
    # model: ActiveRecord model
    # reflection: ActiveRecord::Reflection::AssociationReflection
    #
    # Given `Foo.belongs_to(:bar)`
    # And `Bar.has_many(:foos)`
    # And <reflection> is the belongs_to reflection
    # Then mirror?(Bar, reflection) returns true
    #
    # Given `Foo.belongs_to(:foable, polymorphic: true)`
    # And `Bar.has_many(:foos, as: :foable)`
    # And `Baz.has_many(:foos, as: :foable)`
    # And <reflection> is the Foo "belongs_to" reflection
    # Then mirror?(Bar, reflection) returns true
    # And mirror?(Baz, reflection) returns true
    def mirror?(model, reflection)
      if reflection.options[:polymorphic]
        model.reflections.values.any? do |model_reflection|
          model_reflection.options[:as] == reflection.name
        end
      else
        model == reflection.klass
      end
    end
  end
end
