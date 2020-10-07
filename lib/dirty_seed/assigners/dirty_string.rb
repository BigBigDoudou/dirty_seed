# frozen_string_literal: true

module DirtySeed
  module Assigners
    # draws a String matching validators
    class DirtyString < DirtyAssigner
      # returns a String matching all validators
      def value
        "lorem ipsum #{('a'..'z').to_a[sequence]}"
      end
    end
  end
end
