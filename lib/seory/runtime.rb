module Seory
  class Runtime
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

    def action_name
      @controller.action_name
    end
  end
end
