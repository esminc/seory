require 'seory'

module Seory
  class Helper
    module Dsl
      def rails_helper_methods(*args)
        delegate(*args, to: :helper)
      end
    end

    def initialize(&block)
      @block = block
    end

    def apply!(runtime)
      @module ||= modulize(@block)

      runtime.extend(@module)
    end

    private

    def modulize(block)
      Module.new do
        extend ::Seory::Helper::Dsl

        module_eval(&block)
      end
    end
  end
end

