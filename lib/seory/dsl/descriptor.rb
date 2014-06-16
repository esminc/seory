require 'seory/page_condition/build_dsl'

module Seory
  module Dsl
    class Descriptor
      include Seory::PageCondition::BuildDsl

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
