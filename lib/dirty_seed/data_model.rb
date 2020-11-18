# frozen_string_literal: true

module DirtySeed
  # Represents the data model
  class DataModel
    include Singleton
    attr_accessor :logs

    class << self
      # Defines class methods forwarding to instance methods
      %i[seed models active_record_models print_logs].each do |method_name|
        define_method(method_name) { instance.public_send(method_name) }
      end

      # Returns dirty model if method_name matches its name
      # @return [DirtySeed::DirtyModel]
      # @raise [NoMethodError] if method_name does not match any dirty model
      def method_missing(method_name, *args, &block)
        models.find do |model|
          model.name.underscore.to_sym == method_name
        end || super
      end

      # Returns true if method_name matches a dirty model name
      # @return [Boolean]
      def respond_to_missing?(method_name, include_private = false)
        models.any? do |model|
          model.name.underscore.to_sym == method_name
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
    # @return [void]
    def seed
      # check if ApplicationRecord is defined first
      ::ApplicationRecord && 3.times { models.each(&:seed) }
      print_logs
    end

    # Returns an dirty models
    # @return [Array<DirtySeed::DirtyModel>]
    def models
      @models ||=
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
      models.sort_by(&:name).each do |model|
        puts model.name
        puts "  created: #{model.seeded}"
        puts "  errors: #{model.errors.join(', ')}" if model.errors.any?
      end
    end
  end
end
