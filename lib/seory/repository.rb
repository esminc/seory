require 'seory/runtime'

module Seory
  class Repository
    def initialize
      @store = []
    end

    def <<(page_contents)
      @store << page_contents
    end

    def lookup(controller)
      page_contents = @store.detect {|page| page.match?(controller) }
      Seory::Runtime.new(page_contents, controller)
    end
  end
end
