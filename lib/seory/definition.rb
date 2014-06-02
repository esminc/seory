module Seory
  class Definition
    def initialize(match = nil)
      @match       = match
      @definitions = {}
    end

    def define(name, value = nil, &block)
      @definitions[name] = block_given? ? block : value
    end

    def definition_for(name)
      @definitions[name]
    end

    def match?(controller)
      return true if @match == :default

      @match == action_slug(controller)
    end

    private

    def action_slug(controller)
      [controller.controller_name, controller.action_name].join('#')
    end
  end
end
