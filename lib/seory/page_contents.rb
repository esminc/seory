require 'seory'
require 'seory/page_condition'

require 'active_support/all'

module Seory
  class EmptyCondition < ::Seory::Error; end
  class AliasNameTaken < ::Seory::Error; end

  class PageContents

    attr_reader :assign_name_aliases

    def initialize(*conditions, &block)
      @conditions  =
        if block_given?
          [PageCondition::BlockCondition.new(block)]
        else
          conditions.map {|condition| Seory::PageCondition[condition] }
        end

      raise EmptyCondition if @conditions.blank?

      @contents, @assign_name_aliases = {}, []
    end

    def define(name, value = nil, &block)
      @contents[name] = block_given? ? block : value
    end

    def alias_assigns(*assign_names)
      if (taken = Seory::CONTENTS & assign_names).size > 0
        raise AliasNameTaken, taken.join(', ')
      end

      assign_name_aliases.concat(assign_names)
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
