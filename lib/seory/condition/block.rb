require 'seory/condition/base'

module Seory
  module Condition
    class Block < Base
      def initialize(block)
        @block = block
      end

      def match?(controller)
        @block.call(controller)
      end
    end
  end
end
