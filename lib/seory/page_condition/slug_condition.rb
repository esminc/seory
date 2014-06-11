module Seory
  module PageCondition
    class SlugCondition
      def self.supposable?(condition_object)
        controller, action = condition_object.to_s.split('#')
        controller && action
      end

      def initialize(slug)
        @slug = slug
      end

      def match?(controller)
        action_slug(controller) == @slug
      end

      def action_slug(controller)
        [controller.controller_name, controller.action_name].join('#')
      end
    end
  end
end
