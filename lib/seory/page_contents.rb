require 'seory'
require 'seory/page_condition'

require 'active_support/all'

module Seory
  class EmptyCondition < ::Seory::Error; end

  class PageContents
    def initialize(*conditions, &block)
      @conditions  = block_given? ? block : conditions
      raise EmptyCondition if @conditions.blank?

      @contents = {}
    end

    def define(name, value = nil, &block)
      @contents[name] = block_given? ? block : value
    end

    def content_for(name)
      @contents[name]
    end

    def match?(controller)
      return true if default?

      if @conditions.respond_to?(:call)
        @conditions.call(controller)
      else
        @conditions.
          map {|condition| Seory::PageCondition.suppose(condition) }.
          any? {|condition| condition.match?(controller) }
      end
    end

    def default?
      @conditions == [:default]
    end
  end
end
