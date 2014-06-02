require 'seory'
require 'active_support/all'

module Seory
  class EmptyCondition < ::Seory::Error; end

  class Definition
    def initialize(*conditions, &block)
      @conditions  = block_given? ? block : conditions
      raise EmptyCondition if @conditions.blank?

      @definitions = {}
    end

    def define(name, value = nil, &block)
      @definitions[name] = block_given? ? block : value
    end

    def definition_for(name)
      @definitions[name]
    end

    def match?(controller)
      return true if @conditions == [:default]

      if @conditions.respond_to?(:call)
        @conditions.call(controller)
      else
        @conditions.include?(action_slug(controller))
      end
    end

    private

    def action_slug(controller)
      [controller.controller_name, controller.action_name].join('#')
    end
  end
end
