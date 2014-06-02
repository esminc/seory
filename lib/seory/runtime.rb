# TODO move somewhere
require 'active_support/all'

module Seory
  class Runtime
    delegate :action_name, to: :controller

    attr_reader :controller

    def initialize(definition, controller)
      @definition = definition
      @controller = controller
    end

    def title
      case definition = @definition.definition_for(:title)
      when String
        definition
      when ->(o) { o.respond_to?(:call) }
        instance_exec(&definition)
      else
        raise 'BUG'
      end
    end
  end
end
