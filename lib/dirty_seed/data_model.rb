# frozen_string_literal: true

module DirtySeed
  # Represents the data model
  class DataModel
    include Singleton
    attr_accessor :logs

    class << self
      # Defines class methods forwarding to instance methods
      %i[dirty_models active_record_models print_logs reset].each do |method_name|
        define_method(method_name) { instance.public_send(method_name) }
      end

      # Calls instance #seed method with count
      # @param [count] count of record to seed for each model
      # @return [void]
      def seed(count)
        instance.seed(count)
      end

      # Returns dirty model if method_name matches its name
      # @return [DirtySeed::DirtyModel]
      # @raise [NoMethodError] if method_name does not match any dirty model
      def method_missing(method_name, *args, &block)
        dirty_models.find do |dirty_model|
          dirty_model.name.underscore.to_sym == method_name
        end || super
      end

      # Returns true if method_name matches a dirty model name
      # @return [Boolean]
      def respond_to_missing?(method_name, include_private = false)
        dirty_models.any? do |dirty_model|
          dirty_model.name.underscore.to_sym == method_name
        end || super
      end
    end

    # Initializes an instance
    # @return [DirtySeed::DataModel]
    def initialize
      Rails.application.eager_load!
      @logs = {}
    end

    # Seeds the database with dirty instances
    # @param [count] count of record to seed for each model
    # @return [void]
    def seed(count)
      # check if ApplicationRecord is defined first (or raise error)
      ::ApplicationRecord &&
        dirty_models.each { |dirty_model| dirty_model.seed(count) }
      print_logs
    end

    # Returns dirty models
    # @return [Array<DirtySeed::DirtyModel>]
    def dirty_models
      @dirty_models ||=
        active_record_models.map do |active_record_model|
          DirtySeed::DirtyModel.new(active_record_model)
        end
    end

    # Returns ApplicationRecord inherited classes sorted by their associations
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def active_record_models
      @active_record_models ||=
        DirtySeed::Sorter.new(unsorted_active_record_models).sort!
    end

    # Returns an ApplicationRecord inherited classes
    # @return [Array<Class>] a class inheriting from ApplicationRecord
    def unsorted_active_record_models
      ::ApplicationRecord.descendants.reject(&:abstract_class)
    end

    # Prints logs in the console
    # @return [void]
    def print_logs
      dirty_models.sort_by(&:name).each do |dirty_model|
        puts dirty_model.name
        puts "  created: #{dirty_model.seeded}"
        puts "  errors: #{dirty_model.errors.join(', ')}" if dirty_model.errors.any?
      end
    end

    # Reset instances
    # @return [void]
    def reset
      @logs = nil
      @dirty_models = nil
      @active_record_models = nil
    end
  end
end
