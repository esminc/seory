require 'seory/rails_helper'

module Seory
  class ViewContextDouble
    include Seory::RailsHelper

    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end
  end
end
