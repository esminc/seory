module Seory
  class ControllerDouble
    attr_reader :params

    def initialize(slug, params = {}, &block)
      @__slug   = slug
      @params = params

      instance_eval(&block) if block
    end

    def controller_name
      controller_path.split('/').last
    end

    def controller_path
      @__slug.split('#').first
    end

    def action_name
      @__slug.split('#').last
    end

    def params
      @params.merge(controller: controller_path, action: action_name)
    end

    def view_assigns
      instance_variables.each_with_object({}) do |ivar, assigns|
        name = ivar.to_s
        next if name.start_with?('@__') || name == '@params'

        assigns[name[1..-1]] = instance_variable_get(ivar)
      end
    end
  end
end
