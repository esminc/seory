module Seory
  module Condition
    class Block
      def initialize(block)
        @block = block
      end

      def match?(controller)
        @block.call(controller)
      end
    end
  end
end
