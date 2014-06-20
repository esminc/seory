module Seory
  autoload :RailsHelper, 'seory/rails_helper'

  class Railtie < ::Rails::Railtie
    initializer 'seory' do |app|
      config_dir = (Rails.root + Seory.config_dir)

      app.config.to_prepare { config_dir.each_child {|src| src.extname == '.rb' && load(src) } }
    end
  end
end
