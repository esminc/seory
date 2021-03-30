module Seory
  module Condition
    class Base
      class << self
        # Override this in each subclasses
        def supposable?(*)
          false
        end

        def suppose(condition)
          subclasses.sort_by(&:to_s).detect {|klass| klass.supposable?(condition) }
        end
      end
    end
  end
end
