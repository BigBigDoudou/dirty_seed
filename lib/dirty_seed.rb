# frozen_string_literal: true

require 'faker'

require_relative 'dirty_seed/engine'
require_relative 'dirty_seed/exceptions'

module DirtySeed
  autoload :Association, 'dirty_seed/association'
  autoload :Attribute, 'dirty_seed/attribute'
  autoload :DataModel, 'dirty_seed/data_model'
  autoload :Model, 'dirty_seed/model'
  autoload :MethodMissingHelper, 'dirty_seed/method_missing_helper'
  autoload :Sorter, 'dirty_seed/sorter'

  module Assigners
    autoload :Assigner, 'dirty_seed/assigners/assigner'
    autoload :Base, 'dirty_seed/assigners/base'
    autoload :Boolean, 'dirty_seed/assigners/boolean'
    autoload :Date, 'dirty_seed/assigners/date'
    autoload :Float, 'dirty_seed/assigners/float'
    autoload :Integer, 'dirty_seed/assigners/integer'
    autoload :Number, 'dirty_seed/assigners/number'
    autoload :String, 'dirty_seed/assigners/string'
    autoload :Time, 'dirty_seed/assigners/time'
  end
end
