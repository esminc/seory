require 'spec_helper'
require 'seory/dsl'

describe Seory::Dsl do
  subject(:seory) { seory_class.lookup(controller) }

  context 'with traditional syntax' do
    let(:seory_class) { Object.new.extend(Seory::Dsl) }
    before do
      seory_class.describe('Group A') do
        match ->(c) { c.controller_name == 'reports' } do
          title 'Useful reports'
        end

        match 'products#index' do
          title 'My Great Product'
          h1    'Great Product Name'

          misc :option, 'static optional val'
        end

        default do
          title 'Misc site'
          h1    { controller.controller_name.upcase }
          h2    'default h2'

          misc(:option) { "dynamic option name at #{controller.controller_name}" }
        end
      end
    end

    context 'at reports#index / match with proc' do
      let(:controller) { double('controller', controller_name: 'reports', controller_path: 'reports', action_name: 'index') }

      specify { expect(seory.title).to eq 'Useful reports' }

      specify do
        expect(seory_class.send(:seory_repository)['Group A']).to include(seory.page_contents)
      end
    end

    context 'at products#index' do
      let(:controller) { double('controller', controller_name: 'products', controller_path: 'products', action_name: 'index') }

      specify { expect(seory.title).to eq 'My Great Product' }
      specify { expect(seory.h1).to eq 'Great Product Name' }
      specify { expect(seory.misc(:option)).to eq 'static optional val' }

      specify { expect(seory.h2).to eq 'default h2' }
    end

    context 'at misc#show' do
      let(:controller) { double('controller', controller_name: 'misc', controller_path: 'misc', action_name: 'show') }

      specify { expect(seory.h1).to eq 'MISC' }
      specify { expect(seory.misc(:option)).to eq 'dynamic option name at misc' }
    end
  end

  context 'accessor to assign' do
    let(:seory_class) { Object.new.extend(Seory::Dsl) }
    let(:controller) do
      controller_double('products#show') { @product = OpenStruct.new(name: 'seory') }
    end

    before do
      seory_class.describe do
        match slug('products#show') do
          assign_reader :product
          title { product.name }
        end
      end
    end

    specify { expect(seory.title).to eq 'seory' }
  end

  context 'with matcher build dsl syntax' do
    let(:seory_class) { Object.new.extend(Seory::Dsl) }
    before do
      seory_class.describe do
        match path('/products/special-product') do
          title 'Special Product Detail'
        end

        match slug('products#show') do
          title 'Great Product Detail'
        end
      end
    end

    context 'at products#show' do
      let(:controller) do
        double('controller', controller_name: 'products', controller_path: 'products', action_name: 'show', params: {id: 42}).tap do |c|
          allow(c).to receive_message_chain(:request, :fullpath) { '/products/42' }
        end
      end

      specify { expect(seory.title).to eq 'Great Product Detail' }
    end

    context 'at special product with path /products/special-product (although products#show)' do
      let(:controller) do
        double('controller', controller_name: 'products', action_name: 'show').tap do |c|
          allow(c).to receive_message_chain(:request, :fullpath) { '/products/special-product' }
        end
      end

      specify { expect(seory.title).to eq 'Special Product Detail' }
    end
  end

end
