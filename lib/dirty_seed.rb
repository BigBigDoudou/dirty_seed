# frozen_string_literal: true

require_relative 'dirty_seed/engine'
require_relative 'dirty_seed/exceptions'

module DirtySeed
  autoload :DataModel, 'dirty_seed/data_model'
  autoload :DirtyAssociation, 'dirty_seed/dirty_association'
  autoload :DirtyAttribute, 'dirty_seed/dirty_attribute'
  autoload :DirtyModel, 'dirty_seed/dirty_model'
  autoload :MethodMissingHelper, 'dirty_seed/method_missing_helper'
  autoload :Sorter, 'dirty_seed/sorter'

  module Assigners
    autoload :DirtyAssigner, 'dirty_seed/assigners/dirty_assigner'
    autoload :DirtyBoolean, 'dirty_seed/assigners/dirty_boolean'
    autoload :DirtyDate, 'dirty_seed/assigners/dirty_date'
    autoload :DirtyFloat, 'dirty_seed/assigners/dirty_float'
    autoload :DirtyInteger, 'dirty_seed/assigners/dirty_integer'
    autoload :DirtyNumber, 'dirty_seed/assigners/dirty_number'
    autoload :DirtyString, 'dirty_seed/assigners/dirty_string'
    autoload :DirtyTime, 'dirty_seed/assigners/dirty_time'
  end
end
