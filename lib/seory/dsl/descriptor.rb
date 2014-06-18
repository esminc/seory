require 'seory/page_group'
require 'seory/condition/build_dsl'

module Seory
  module Dsl
    class Descriptor
      include Seory::Condition::BuildDsl

      def initialize(group_name, repository)
        @page_group = PageGroup.new(group_name)
        @repository = repository
      end

      def describe(&block)
        instance_exec(&block)

        @page_group
      end

      def match(*conditions, &def_builder)
        @page_group.add PageBuilder.new(*conditions).build!(&def_builder)
      end

      def default(&def_builder)
        @page_group.default = PageBuilder.new(:default).build!(&def_builder)
      end
    end
  end
end
