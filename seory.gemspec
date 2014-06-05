# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seory/version'

Gem::Specification.new do |spec|
  spec.name          = "seory"
  spec.version       = Seory::VERSION
  spec.authors       = ["moro"]
  spec.email         = ["moronatural@gmail.com"]
  spec.summary       = %q{SEO contents manager for Rails.}
  spec.description   = %q{Manage SEO contets in Rails app. based on controller, action and more complex context.}
  spec.homepage      = "https://github.com/esminc/seory"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "> 3.2"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
