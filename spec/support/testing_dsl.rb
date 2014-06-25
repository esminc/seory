module Seory
  module TestingDsl
    def controller_double(*args, &block)
      Seory::ControllerDouble.new(*args, &block)
    end

    def view_context_double(*args, &block)
      Seory::ViewContextDouble.new(controller_double(*args, &block))
    end
  end
end
