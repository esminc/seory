require 'seory/version'
require 'seory/railtie' if defined?(Rails)

module Seory
  CONTENTS = %w[title h1 h2 meta_description meta_keywords canonical_url og_image_url].map(&:to_sym)

  class Error < RuntimeError; end

  autoload :Dsl,'seory/dsl'

  mattr_accessor :config_dir
  self.config_dir = 'config/seory'

  class << self
    def describe(*args, &block)
      @object ||= Object.new.tap {|obj| obj.extend Seory::Dsl }

      @object.describe(*args, &block)
    end
    alias seo_content describe

    def default_repository
      @object.send(:seory_repository)
    end
  end
end
