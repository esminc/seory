require "seory/version"

module Seory
  CONTENTS = %w[title h1 h2 meta_description meta_keywords canonical_url og_image_url].map(&:to_sym)

  class Error < RuntimeError
  end

  autoload :Dsl,         'seory/dsl'
  autoload :RailsHelper, 'seory/rails_helper'

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
