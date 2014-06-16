require 'seory'
require 'seory/repository'

module Seory
  module Dsl
    def describe(&block)
      Descriptor.new(seory_repository).describe(&block)
    end
    alias seo_content describe

    def lookup(controller)
      seory_repository.lookup(controller)
    end

    private

    def seory_repository
      @__seory_repository ||= Repository.new
    end

    autoload :PageContentsBuilder, 'seory/dsl/page_contents_builder'
    autoload :Descriptor,          'seory/dsl/descriptor'
  end
end
