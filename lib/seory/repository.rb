require 'seory/runtime'

module Seory
  class DuplicateDefault < Seory::Error; end

  class Repository
    class << self
      def extract_label_from_trace(trace)
        trace.first.split(':').first
      end
    end

    attr_accessor :helper

    def initialize
      @page_groups = []
    end

    def <<(page_group)
      remove_old_group!(page_group.name)

      @page_groups << page_group

      clear_page_order_pre_calculation!
    end

    def lookup(controller)
      page = pre_orderd_pages.detect {|pg| pg.match?(controller) } || default

      Seory::Runtime.new(page, controller, default).tap do |runtime|
        runtime.extend helper if helper
      end
    end

    def default
      @default ||=
        @page_groups.map(&:default).compact.tap {|defaults|
          raise DuplicateDefault if defaults.size > 1
        }.first
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
      @default = nil
    end
  end
end
