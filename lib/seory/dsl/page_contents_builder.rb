require 'seory'
require 'seory/page_contents'

module Seory
  module Dsl
    class PageContentsBuilder
      def initialize(*conditions)
        @page_contents =
          if conditions.size == 1 && (block = conditions.first).is_a?(Proc)
            PageContents.new(&block)
          else
            PageContents.new(*conditions)
          end
      end

      def build!(&block)
        instance_exec(&block)

        @page_contents
      end

      def misc(name, val = nil, &block)
        @page_contents.define(name, val, &block)
      end

      def assign_reader(*names)
        @page_contents.assign_reader(*names)
      end

      Seory::CONTENTS.each do |name|
        define_method(name) {|val = nil, &block| misc(name, val, &block) }
      end
    end
  end
end
