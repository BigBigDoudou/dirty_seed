# frozen_string_literal: true

module DirtySeed
  # forwards missing method to another object if it matches
  module MethodMissingHelper
    # defines missing_method and respond_to_missing? methods
    def forward_missing_methods_to(addressee_key)
      define_addressee(addressee_key)
      define_method_missing
      define_respond_to_missing?
    end

    # defines addressee method
    def define_addressee(addressee_key)
      define_method :addressee do
        public_send(addressee_key)
      end
    end

    # defines missing_method method so it returns the adressee or calls super
    # e.g. calling #name on a DirtyModel instance will call name on its @model object
    def define_method_missing
      define_method :method_missing do |method_name, *args, &block|
        return super(method_name, *args, &block) unless addressee.respond_to?(method_name)

        addressee.public_send(method_name, *args, &block)
      end
    end

    # defines respond_to_missing? method to matches the method_missing behavior
    def define_respond_to_missing?
      define_method :respond_to_missing? do |method_name, _include_private = false|
        # :nocov:
        return super(method_name, _include_private = false) unless addressee.respond_to?(method_name)

        true
        # :nocov:
      end
    end
  end
end
