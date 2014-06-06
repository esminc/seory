require 'seory'
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
        @conditions.any? do |condition|
          case condition
          when Hash
            controller.params.slice(*condition.keys).symbolize_keys == condition
          else
            action_slug(controller) == condition
          end
        end
      end
    end

    def default?
      @conditions == [:default]
    end

    private

    def action_slug(controller)
      [controller.controller_name, controller.action_name].join('#')
    end
  end
end
