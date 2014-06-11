require 'seory'
require 'seory/page_condition/params_condition'
require 'seory/page_condition/slug_condition'

module Seory
  module PageCondition
    class SupposionFailed < Seory::Error; end
    extend self

    def suppose(condition)
      klass = [ParamsCondition, SlugCondition].detect {|klass| klass.supposable?(condition) }
      raise SupposionFailed unless klass

      klass.new(condition)
    end
  end
end
