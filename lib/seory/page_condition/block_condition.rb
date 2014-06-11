module Seory
  module PageCondition
    class BlockCondition
      def initialize(block)
        @block = block
      end

      def match?(controller)
        @block.call(controller)
      end
    end
  end
end
