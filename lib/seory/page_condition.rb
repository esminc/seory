require 'seory'
require 'seory/page_condition/block_condition'
require 'seory/page_condition/default_condition'
require 'seory/page_condition/params_condition'
require 'seory/page_condition/path_condition'
require 'seory/page_condition/slug_condition'

module Seory
  module PageCondition
    class SupposionFailed < Seory::Error; end
    extend self

    def [](condition)
      if condition == :default
        DefaultCondition.new
      elsif condition.respond_to?(:match?)
        condition
      else
        suppose(condition)
      end
    end

    private

    def suppose(condition)
      klass = [ParamsCondition, SlugCondition].detect {|klass| klass.supposable?(condition) }
      raise SupposionFailed.new(condition.inspect) unless klass

      klass.new(condition)
    end
  end
end
