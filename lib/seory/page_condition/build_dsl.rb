require 'seory/page_condition'

module Seory
  module Condition
    module BuildDsl
      def slug(slug)
        Slug.new(slug)
      end

      def path(path)
        Path.new(path)
      end

      def params(params)
        Params.new(params)
      end
    end
  end
end
