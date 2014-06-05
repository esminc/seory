require 'seory'
require 'seory/page_contents'
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

      def misc(name, val = nil, &block)
        @page_contents.define(name, val, &block)
      end

      Seory::CONTENTS.each do |name|
        define_method(name) {|val = nil, &block| misc(name, val, &block) }
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
