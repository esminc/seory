require 'seory/page_condition'

module Seory
  module PageCondition
    module BuildDsl
      def slug(slug)
        SlugCondition.new(slug)
      end

      def path(path)
        PathCondition.new(path)
      end

      def params(params)
        ParamsCondition.new(params)
      end
    end
  end
end
