require 'spec_helper'
require 'seory'

describe Seory::RailsHelper do
  before do
    Seory.seo_content 'products' do
      match slug('products#index') do
        title 'Product index'

        og_image_url { image_url('top-logo.png') }
      end

      default do
        title 'Default title'
      end
    end

    Seory.seo_content 'Review for products' do
      match slug('products/reviews#index') do
        assign_reader :product

        title { "Reviews for #{bang(product.name)}" }
      end
    end

    Seory.helper do
      rails_helper_methods :image_url

      def bang(string); string + ' !!!'; end
    end
  end

  context 'GET /products' do
    let(:context) { view_context_double('products#index') }

    before do
      allow(context).to receive(:image_url) {|img| "http://example.com/assets/#{img}?12345" }
    end

    specify do
      expect(context.seory.title).to eq 'Product index'
    end

    specify do
      expect(context.seory.og_image_url).to eq 'http://example.com/assets/top-logo.png?12345'
    end
  end

  context 'GET /products/a-computer/reviews' do
    let(:context) do
      view_context_double('products/reviews#index') do
        @product = OpenStruct.new(name: 'a-computer')
      end
    end

    specify do
      expect(context.seory.title).to eq "Reviews for a-computer !!!"
    end
  end

  context 'GET /users' do
    let(:context) do
      Seory::ViewContextDouble.new(controller_double('users#index'))
    end

    specify do
      expect(context.seory.title).to eq 'Default title'
    end
  end
end
