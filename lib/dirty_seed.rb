# frozen_string_literal: true

require 'faker'

require_relative 'dirty_seed/engine'

module DirtySeed
  autoload :Association, 'dirty_seed/association'
  autoload :Attribute, 'dirty_seed/attribute'
  autoload :DataModel, 'dirty_seed/data_model'
  autoload :Logger, 'dirty_seed/logger'
  autoload :Model, 'dirty_seed/model'
  autoload :Seeder, 'dirty_seed/seeder'
  autoload :Sorter, 'dirty_seed/sorter'

  module Assigners
    autoload :Assigner, 'dirty_seed/assigners/assigner'
    autoload :Dispatcher, 'dirty_seed/assigners/dispatcher'
    autoload :Inclusion, 'dirty_seed/assigners/inclusion'
    autoload :Meaningful, 'dirty_seed/assigners/meaningful'
    autoload :FakerHelper, 'dirty_seed/assigners/helpers/faker_helper'
    autoload :MinMaxHelper, 'dirty_seed/assigners/helpers/min_max_helper'
    autoload :RegexHelper, 'dirty_seed/assigners/helpers/regex_helper'
    module Type
      autoload :Boolean, 'dirty_seed/assigners/type/boolean'
      autoload :Date, 'dirty_seed/assigners/type/date'
      autoload :Float, 'dirty_seed/assigners/type/float'
      autoload :Integer, 'dirty_seed/assigners/type/integer'
      autoload :Json, 'dirty_seed/assigners/type/json'
      autoload :String, 'dirty_seed/assigners/type/string'
      autoload :Time, 'dirty_seed/assigners/type/time'
    end
  end
end
