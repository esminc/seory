require "seory/version"

module Seory
  CONTENTS = %w[title h1 h2 meta_description meta_keywords canonical_url image_url].map(&:to_sym)

  class Error < RuntimeError
  end

  autoload :Dsl, 'seory/dsl'
end
