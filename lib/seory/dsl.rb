require 'seory/page_contents'
require 'seory/runtime'

module Seory
  module Dsl
    extend self

    def describe(&block)
      [].tap do |repositories|
        Descriptor.new(repositories).instance_exec(&block)
      end
    end

    def lookup(controller)
      page_contents = repositories.detect {|page| page.match?(controller) }
      Seory::Runtime.new(page_contents, controller)
    end

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

    class Descriptor
      def initialize(repositories)
        @repositories = repositories
      end

      def match(*conditions, &def_builder)
        @repositories << PageContentsBuilder.new(*conditions).build!(&def_builder)
      end

      def default(&def_builder)
        match(:default, &def_builder)
      end
    end
  end
end
