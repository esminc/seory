require 'spec_helper'
require 'seory/runtime'
require 'seory/page_contents'

describe Seory::Runtime do
  let(:seory) do
    Seory::Runtime.new(page_contents, controller)
  end

  let(:controller) { double('controller') }
  let(:page_contents) { Seory::PageContents.new(:default) }

  context 'static content' do
    before do
      page_contents.define(:title, 'A title')
      page_contents.define(:h1,    'Most importatnt HEADER 1')
    end

    describe '#title' do
      specify { expect(seory.title).to eq 'A title' }
    end

    describe '#h1' do
      specify { expect(seory.h1).to eq 'Most importatnt HEADER 1' }
    end
  end

  context 'controller based dynamic content' do
    before do
      allow(controller).to receive(:action_name) { 'edit' }

      page_contents.define(:title) { "#{action_name.upcase} | My Site" }
    end

    describe '#titie' do
      specify { expect(seory.title).to eq 'EDIT | My Site' }
    end
  end

  context 'Access controller assigns(instance variables)' do
    before do
      allow(controller).to receive(:view_assigns).and_return('products' => [:products] * 42)

      page_contents.define(:title) { "Good Shop with #{assigns(:products).size} products!" }
    end

    specify { expect(seory.title).to eq 'Good Shop with 42 products!' }
  end

  context 'Custom content created by misc()' do
    before do
      page_contents.define(:custom, 'custom variable')

      page_contents.define(:title) { misc(:custom).upcase }
    end

    specify 'it was also accessible from other content' do
      expect(seory.title).to eq 'CUSTOM VARIABLE'
    end
  end
end
