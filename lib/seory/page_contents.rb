require 'seory'
require 'seory/page_condition'

require 'active_support/all'

module Seory
  class EmptyCondition < ::Seory::Error; end

  class PageContents
    def initialize(*conditions, &block)
      @conditions  =
        if block_given?
          [PageCondition::BlockCondition.new(block)]
        else
          conditions.map {|condition| Seory::PageCondition[condition] }
        end

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

      @conditions.any? {|condition| condition.match?(controller) }
    end

    def default?
      @conditions.all? {|c| c.is_a?(Seory::PageCondition::DefaultCondition) }
    end
  end
end
