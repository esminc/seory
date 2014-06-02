require 'seory/definition'
require 'seory/runtime'

module Seory
  class PageContentsBuilder
    def initialize(*conditions)
      @page_contents = PageContents.new(*conditions)
    end

    def build!(&block)
      instance_exec(&block)

      @page_contents
    end

    Seory::Runtime::CONTENTS.each do |name|
      define_method(name) do |val = nil, &block|
        @page_contents.define(name, val, &block)
      end
    end
  end

  module Dsl
    extend self

    def describe(&block)
      instance_exec(&block)
    end

    def lookup(controller)
      page_contents = repositories.detect {|page| page.match?(controller) }
      Seory::Runtime.new(page_contents, controller)
    end

    def match(*conditions, &def_builder)
      repositories << PageContentsBuilder.new(*conditions).build!(&def_builder)
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
