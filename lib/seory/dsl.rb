require 'seory'
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

    autoload :PageContentsBuilder, 'seory/dsl/page_contents_builder'
    autoload :Descriptor,          'seory/dsl/descriptor'
  end
end
