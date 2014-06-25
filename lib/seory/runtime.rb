require 'seory'

module Seory
  class Runtime
    delegate :controller,  to: '@view_context'
    delegate :action_name, to: :controller

    attr_reader :page_contents

    def initialize(page_contents, view_context, fallback = nil)
      @page_contents = page_contents
      @view_context  = view_context
      @fallback      = fallback

      extend build_assign_accessor_module(@page_contents.assign_name_accessors)
    end

    def assigns(name)
      controller.view_assigns[name.to_s]
    end

    def misc(name)
      calculate_content_for(name)
    end

    def helper
      @view_context
    end

    Seory::CONTENTS.each do |name|
      define_method(name) { misc(name) }
    end

    private

    def calculate_content_for(name)
      case page_content = lookup_content_for(name)
      when Symbol
        calculate_content_for(page_content)
      when ->(o) { o.respond_to?(:call) }
        instance_exec(&page_content)
      else
        page_content.to_s
      end
    end

    def lookup_content_for(name)
      @page_contents.content_for(name) || \
      @fallback.try {|fb| fb.content_for(name) }
    end

    def build_assign_accessor_module(names)
      Module.new do
        Array(names).each do |name|
          define_method(name) { assigns(name) }
        end
      end
    end

  end
end
