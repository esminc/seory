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
      clear_page_order_pre_calculation!

      @page_groups << page_group
    end

    def lookup(controller)
      page = pre_orderd_pages.detect {|pg| pg.match?(controller) }

      Seory::Runtime.new(page, controller, default)
    end

    def default
      pre_orderd_pages.detect(&:default?)
    end

    private

    def pre_orderd_pages
      @pre_orderd_pages ||= @page_groups.sort_by(&:name).flat_map(&:pages)
    end

    def remove_old_group!(page_group_name)
      @page_groups.reject! {|pg| pg.name == page_group_name }
    end

    def clear_page_order_pre_calculation!
      @pre_orderd_pages = nil
    end
  end
end
