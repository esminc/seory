# TODO move somewhere
require 'active_support/all'

module Seory
  class Runtime
    delegate :action_name, to: :controller

    CONTENTS = %w[title h1 h2 meta_description meta_keywords canonical_url image_url].map(&:to_sym)

    attr_reader :controller

    def initialize(page_contents, controller)
      @page_contents = page_contents
      @controller    = controller
    end

    CONTENTS.each do |name|
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
