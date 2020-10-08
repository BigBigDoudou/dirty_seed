# frozen_string_literal: true

require_relative 'dirty_seed/engine'
require_relative 'dirty_seed/exceptions'

module DirtySeed
  autoload :MethodMissingHelper, 'dirty_seed/method_missing_helper'
  autoload :DataModel, 'dirty_seed/data_model'
  autoload :DirtyModel, 'dirty_seed/dirty_model'
  autoload :DirtyAssociation, 'dirty_seed/dirty_association'
  autoload :DirtyAttribute, 'dirty_seed/dirty_attribute'
  autoload :Sorter, 'dirty_seed/sorter'

  module Assigners
    autoload :DirtyAssigner, 'dirty_seed/assigners/dirty_assigner'
    autoload :DirtyBoolean, 'dirty_seed/assigners/dirty_boolean'
    autoload :DirtyInteger, 'dirty_seed/assigners/dirty_integer'
    autoload :DirtyFloat, 'dirty_seed/assigners/dirty_float'
    autoload :DirtyString, 'dirty_seed/assigners/dirty_string'
    autoload :DirtyDate, 'dirty_seed/assigners/dirty_date'
    autoload :DirtyTime, 'dirty_seed/assigners/dirty_time'
  end
end
