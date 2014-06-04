require 'seory/page_contents'
require 'seory/runtime'
require 'seory/repository'

module Seory
  module Dsl

    def describe(&block)
      @repository = Repository.new
      Descriptor.new(@repository).describe(&block)
    end

    def lookup(controller)
      @repository.lookup(controller)
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
      def initialize(repository)
        @repository = repository
      end

      def describe(&block)
        instance_exec(&block)

        @repository
      end

      def match(*conditions, &def_builder)
        @repository << PageContentsBuilder.new(*conditions).build!(&def_builder)
      end

      def default(&def_builder)
        match(:default, &def_builder)
      end
    end
  end
end
