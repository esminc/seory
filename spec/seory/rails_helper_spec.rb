require 'spec_helper'
require 'seory'

describe Seory::RailsHelper do
  before do
    Seory.seo_content 'products' do
      match slug('products#index') do
        title 'Product index'
      end

      default do
        title 'Default title'
      end
    end

    Seory.seo_content 'Review for products' do
      match slug('products/reviews#index') do
        assign_reader :product

        title { "Reviews for #{product.name}" }
      end
    end
  end

  context 'GET /products' do
    let(:context) do
      Seory::ViewContextDouble.new(controller_double('products#index'))
    end

    specify do
      expect(context.seory.title).to eq 'Product index'
    end
  end

  context 'GET /products/a-computer/reviews' do
    let(:context) do
      controller = controller_double('products/reviews#index') do
        @product = OpenStruct.new(name: 'a-computer')
      end

      Seory::ViewContextDouble.new(controller)
    end

    specify do
      expect(context.seory.title).to eq "Reviews for a-computer"
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
