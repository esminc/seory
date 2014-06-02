module Seory
  class Runtime
    def initialize(definition, controller)
      @definition = definition
      @controller = controller
    end

    def title
      @definition.definition_for(:title)
    end
  end
end
