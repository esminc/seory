require 'seory'
require 'seory/page_condition/block_condition'
require 'seory/page_condition/default_condition'
require 'seory/page_condition/params_condition'
require 'seory/page_condition/path_condition'
require 'seory/page_condition/slug_condition'

module Seory
  module Condition
    class SupposionFailed < Seory::Error; end
    extend self

    def [](condition)
      if condition == :default
        Default.new
      elsif condition.respond_to?(:match?)
        condition
      else
        suppose(condition)
      end
    end

    private

    def suppose(condition)
      condition_class = [Params, Slug].detect {|klass| klass.supposable?(condition) }
      raise SupposionFailed.new(condition.inspect) unless condition_class

      condition_class.new(condition)
    end
  end
end
