require 'seory/definition'
require 'seory/runtime'

module Seory
  class DefinitionBuilder
    def initialize(*conditions)
      @definition = Definition.new(*conditions)
    end

    def build!(&block)
      instance_exec(&block)

      @definition
    end

    Seory::Runtime::CONTENTS.each do |name|
      define_method(name) do |val = nil, &block|
        @definition.define(name, val, &block)
      end
    end
  end

  module Dsl
    extend self

    def describe(&block)
      instance_exec(&block)
    end

    def lookup(controller)
      definition = repositories.detect {|definition| definition.match?(controller) }
      Seory::Runtime.new(definition, controller)
    end

    def match(*conditions, &def_builder)
      repositories << DefinitionBuilder.new(*conditions).build!(&def_builder)
    end

    def default(&def_builder)
      match(:default, &def_builder)
    end

    private

    def repositories
      @repositories ||= []
    end
  end
end
