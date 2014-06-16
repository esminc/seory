require 'seory/runtime'

module Seory
  class Repository
    class << self
      def extract_label_from_trace(trace)
        trace.first.split(':').first
      end
    end

    def initialize
      @store = Hash.new {|h, k| h[k] = Array.new }
    end

    def [](group_name)
      @store[group_name]
    end

    def lookup(controller)
      page_contents = pages.detect {|page| page.match?(controller) }

      Seory::Runtime.new(page_contents, controller, default)
    end

    def default
      pages.detect(&:default?)
    end

    private

    def pages
      @store.values.flatten
    end
  end
end
