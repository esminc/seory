require 'seory'
require 'seory/repository'

module Seory
  module Dsl
    def describe(group_name = Repository.extract_label_from_trace(caller), &block)
      seory_repository << PageGroupBuilder.new(group_name, seory_repository).describe(&block)
    end
    alias seo_content describe

    def helper(&block)
      seory_repository.helper = Module.new(&block)
    end

    def lookup(controller)
      seory_repository.lookup(controller)
    end

    private

    def seory_repository
      @__seory_repository ||= Repository.new
    end

    autoload :PageBuilder,      'seory/dsl/page_builder'
    autoload :PageGroupBuilder, 'seory/dsl/page_group_builder'
  end
end
