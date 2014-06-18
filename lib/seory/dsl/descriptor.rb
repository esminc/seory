require 'seory/page_condition/build_dsl'

module Seory
  module Dsl
    class Descriptor
      include Seory::Condition::BuildDsl

      def initialize(group_name, repository)
        @group_name = group_name
        @repository = repository
      end

      def describe(&block)
        instance_exec(&block)

        @repository
      end

      def match(*conditions, &def_builder)
        page_contents = PageBuilder.new(*conditions).build!(&def_builder)
        @repository.add(@group_name, page_contents)
      end

      def default(&def_builder)
        match(:default, &def_builder)
      end
    end
  end
end
