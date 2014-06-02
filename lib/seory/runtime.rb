# TODO move somewhere
require 'active_support/all'

module Seory
  class Runtime
    delegate :action_name, to: :controller

    CONTENTS = %w[title h1 h2 meta_desc meta_keywords canonical_url image_url].map(&:to_sym)

    attr_reader :controller

    def initialize(definition, controller)
      @definition = definition
      @controller = controller
    end

    CONTENTS.each do |name|
      define_method(name) { calculate_content_for(name) }
    end

    private

    def calculate_content_for(name)
      case definition = @definition.definition_for(name)
      when String
        definition
      when ->(o) { o.respond_to?(:call) }
        instance_exec(&definition)
      else
        raise 'BUG'
      end
    end
  end
end
