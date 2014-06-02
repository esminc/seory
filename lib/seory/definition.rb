module Seory
  class Definition
    def initialize
      @definitions = {}
    end

    def define(name, value)
      @definitions[name] = value
    end

    def definition_for(name)
      @definitions[name]
    end
  end
end
