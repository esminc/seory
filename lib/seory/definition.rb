module Seory
  class Definition
    def initialize
      @definitions = {}
    end

    def define(name, value = nil, &block)
      @definitions[name] = block_given? ? block : value
    end

    def definition_for(name)
      @definitions[name]
    end
  end
end
