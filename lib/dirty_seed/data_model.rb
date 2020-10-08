# frozen_string_literal: true

module DirtySeed
  # represents the data model
  class DataModel
    include Singleton
    attr_accessor :logs

    class << self
      # defines class methods forwarding to instance methods
      %i[seed models active_record_models print_logs].each do |method_name|
        define_method(method_name) { instance.public_send(method_name) }
      end

      # returns dirty model if method_name matches its name
      def method_missing(method_name, *args, &block)
        models.find do |model|
          model.name.underscore.to_sym == method_name
        end || super
      end

      # returns true if method_name matches a dirty model name
      def respond_to_missing?(method_name, include_private = false)
        models.any? do |model|
          model.name.underscore.to_sym == method_name
        end || super
      end
    end

    # initializes an instance - no arguments required
    def initialize
      Rails.application.eager_load!
      @logs = {}
    end

    # seeds the database with dirty instances
    def seed
      # check if ApplicationRecord is defined first
      ::ApplicationRecord && 3.times { models.each(&:seed) }
      print_logs
    end

    # returns an Array of DirtyModel instances
    def models
      @models ||=
        active_record_models.map do |active_record_model|
          DirtySeed::DirtyModel.new(model: active_record_model)
        end
    end

    # returns an Array of ApplicationRecord inherited classes, sorted by their associations
    def active_record_models
      @active_record_models ||=
        DirtySeed::Sorter.new(models: unsorted_active_record_models).sort!
    end

    # returns an Array of ApplicationRecord inherited classes
    def unsorted_active_record_models
      ::ApplicationRecord.descendants.reject(&:abstract_class)
    end

    # prints logs in the console
    def print_logs
      models.sort_by(&:name).each do |model|
        puts model.name
        puts "  created: #{model.seeded}"
        puts "  errors: #{model.errors.join(', ')}" if model.errors.any?
      end
    end
  end
end
