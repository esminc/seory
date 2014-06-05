# TODO move somewhere
require 'active_support/all'
require 'seory'

module Seory
  class Runtime
    delegate :action_name, to: :controller

    attr_reader :controller

    def initialize(page_contents, controller, fallback = nil)
      @page_contents = page_contents
      @controller    = controller
      @fallback      = fallback
    end

    def assigns(name)
      @controller.view_assigns[name.to_s]
    end

    def misc(name)
      calculate_content_for(name)
    end

    Seory::CONTENTS.each do |name|
      define_method(name) { misc(name) }
    end

    private

    def calculate_content_for(name)
      case page_content = lookup_content_for(name)
      when String
        page_content
      when ->(o) { o.respond_to?(:call) }
        instance_exec(&page_content)
      else
        raise 'BUG'
      end
    end

    def lookup_content_for(name)
      @page_contents.content_for(name) || \
      @fallback.try {|fb| fb.content_for(name) }
    end
  end
end
