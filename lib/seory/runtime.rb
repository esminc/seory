# TODO move somewhere
require 'active_support/all'
require 'seory'

module Seory
  class Runtime
    delegate :action_name, to: :controller

    attr_reader :controller

    def initialize(page_contents, controller)
      @page_contents = page_contents
      @controller    = controller
    end

    def assigns(name)
      @controller.view_assigns[name.to_s]
    end

    Seory::CONTENTS.each do |name|
      define_method(name) { calculate_content_for(name) }
    end

    private

    def calculate_content_for(name)
      case page_content = @page_contents.content_for(name)
      when String
        page_content
      when ->(o) { o.respond_to?(:call) }
        instance_exec(&page_content)
      else
        raise 'BUG'
      end
    end
  end
end
