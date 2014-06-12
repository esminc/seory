module Seory
  module TestingDsl
    def controller_double(*args, &block)
      Seory::ControllerDouble.new(*args, &block)
    end
  end
end
