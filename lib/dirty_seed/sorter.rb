# frozen_string_literal: true

module DirtySeed
  # Sorts ActiveRecord models depending on their associations
  class Sorter
    # Initializes an instance
    # @param models [Array<DirtySeed::Model>]
    # @return [DirtySeed::Sorter]
    def initialize(models = [])
      @models = models
    end

    # Sorts models depending on their associations
    # @return [Array<Class>] classes inheriting from ActiveRecord::Base
    # @note Use procedural over fonctional -> do not use recursivity
    def sort
      reset
      until unsorted.empty?
        count_up || break
        self.current = unsorted.first
        sort_current
      end
      sorted
    end

    private

    attr_reader :models
    attr_accessor :checked, :counter, :current, :flexible_dependencies, :sorted, :unsorted

    # Reset state before sorting
    # @return [void]
    def reset
      self.counter = 0
      self.flexible_dependencies = false
      self.unsorted = models.clone
      self.sorted = []
      self.checked = Set.new
    end

    # Updates count or return false if limite is exceeded
    # @return [Boolean]
    def count_up
      return false if counter >= models.count * 5

      self.counter = counter + 1
    end

    # Sort the current model
    # @return [void]
    def sort_current
      flexible_dependencies! if loop?
      insert_or_rotate
    # rescue from errors coming from RDBMS or related
    rescue StandardError
      unsorted.delete(current)
    ensure
      checked << current
    end

    # Is the current model already checked?
    # @return [Boolean]
    def loop?
      checked.include? current
    end

    # Activates flexible_dependencies option to prevent infinite loop
    # @return [void]
    def flexible_dependencies!
      self.flexible_dependencies = true
      self.checked = Set.new
    end

    # Chooses if current should be added to sorted ones or not
    # @return [void]
    def insert_or_rotate
      # if current is independent of any unsorted model
      if independent?
        # removed current from unsorted and add it to sorted
        sorted << unsorted.shift
      else
        # rotate models array so current will be sorted at the end
        unsorted.rotate!
      end
    end

    # Is current independent from any unsorted model?
    # @return [Boolean]
    # @example
    #   Given a model Foo
    #   And Foo.belongs_to(:bar)
    #   And Foo.belongs_to(:zed, optional: true)
    #   And Bar is sorted
    #   And Zed is not sorted yet
    #   If @flexible_dependencies is false (all relations should be sorted)
    #     Then Foo is not independent
    #   Else (required relations should be sorted)
    #     Then Foo is independent
    # @example
    #   Given a model Foo
    #   And Foo.belongs_to(:fooable, polymorphic: true)
    #   And Bar.has_many(:foos, as: :fooable)
    #   And Zed.has_many(:foos, as: :fooable)
    #   And Bar is sorted
    #   And Zed is not sorted yet
    #   If @flexible_dependencies is false (all relations should be sorted)
    #     Then Foo is not independent
    #   Else (at least one relation - in case of polymorpism - should be sorted)
    #     Then Foo is independent
    def independent?
      return true if unsorted.one?

      current.associations.none? { |association| dependent?(association) }
    end

    # Is the association dependent from an unsorted model?
    # @param association [DirtySeed::Association]
    # @return [Boolean]
    def dependent?(association)
      return if flexible_dependencies && association.optional?

      # When flexible_dependencies is activated, at least one polymorphic relation should be sorted
      #   Either, all polymorphic relations should be sorted
      method = flexible_dependencies ? :any? : :all?
      association.associated_models.public_send(method) do |active_record_model|
        unsorted.map(&:__getobj__).include? active_record_model
      end
    end
  end
end
