require 'seory/runtime'

module Seory
  class Repository
    class << self
      def extract_label_from_trace(trace)
        trace.first.split(':').first
      end
    end

    def initialize
      @page_groups = []
    end

    def <<(page_group)
      remove_old_group!(page_group.name)

      @page_groups << page_group
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
      @page_groups.flat_map(&:pages)
    end

    def remove_old_group!(page_group_name)
      @page_groups.reject! {|pg| pg.name == page_group_name }
    end
  end
end
