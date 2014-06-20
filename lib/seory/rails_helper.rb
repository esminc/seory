module Seory
  module RailsHelper
    class << self
      def load_contents_from(path)
        Rails.application.config.to_prepare do
          Pathname.new(path).each_child do |source|
            next unless source.extname == '.rb'
            load source
          end
        end
      end
    end

    def seory(repository = Seory.default_repository)
      repository.lookup(controller)
    end
  end
end
