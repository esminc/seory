require 'seory/runtime'

module Seory
  class DuplicateDefault < Seory::Error; end

  class Repository
    class << self
      def extract_label_from_trace(trace)
        trace.first.split(':').first
      end
    end

    def initialize
      @page_groups = []
      @default_page_group = nil
    end

    def <<(page_group)
      remove_old_group!(page_group.name)

      @page_groups << page_group
      assign_default(page_group)

      clear_page_order_pre_calculation!
    end

    def lookup(controller)
      page = pre_orderd_pages.detect {|pg| pg.match?(controller) } || default

      Seory::Runtime.new(page, controller, default)
    end

    def default
      @default_page_group.try(:default)
    end

    private

    def assign_default(page_group)
      if page_group.default
        raise DuplicateDefault if @default_page_group
        @default_page_group = page_group
      end
    end

    def pre_orderd_pages
      @pre_orderd_pages ||= @page_groups.sort_by(&:name).flat_map(&:pages)
    end

    def remove_old_group!(page_group_name)
      @page_groups.reject! {|pg| pg.name == page_group_name }

      if @default_page_group.try(:name) == page_group_name
        @default_page_group = nil
      end
    end

    def clear_page_order_pre_calculation!
      @pre_orderd_pages = nil
    end
  end
end
