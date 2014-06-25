module Seory
  module RailsHelper
    def seory(repository = Seory.default_repository)
      repository.lookup(self)
    end
  end
end
