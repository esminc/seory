module Seory
  module RailsHelper
    def seory(repository = Seory.default_repository)
      repository.lookup(controller)
    end
  end
end
