require 'seory'
require 'seory/condition/block'
require 'seory/condition/params'
require 'seory/condition/path'
require 'seory/condition/slug'

module Seory
  module Condition
    class SupposionFailed < Seory::Error; end
    extend self

    def [](condition)
      if condition.is_a?(Seory::Condition::Base)
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
