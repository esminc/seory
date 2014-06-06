require 'spec_helper'
require 'seory/page_contents'

describe Seory::PageContents do
  specify 'cant define without condition' do
    expect { Seory::PageContents.new }.to raise_error(Seory::EmptyCondition)
  end

  context 'content PageContents' do
    let(:seory_def) do
      Seory::PageContents.new(:default)
    end

    context 'define static content' do
      before do
        seory_def.define(:title, 'A title')
      end

      specify { expect(seory_def.content_for(:title)).to eq 'A title' }
    end

    context 'define dynamic content' do
      before do
        seory_def.define(:title) { 'A title' }
      end

      specify { expect(seory_def.content_for(:title).call).to eq 'A title' }
    end

    context 'define aliased content' do
      before do
        seory_def.define(:title) { 'A title' }

        seory_def.define(:h1, :title)
      end

      specify { expect(seory_def.content_for(:h1)).to eq :title }
    end
  end

  describe 'condition and #match?' do
    def init_with(*args, &block)
      Seory::PageContents.new(*args, &block)
    end

    let(:controller) { double('controller', controller_name: 'people', action_name: 'index') }

    specify '`:default` matches everything (stacked in bottom)' do
      expect(init_with(:default)).to be_match(double('something'))
    end

    describe 'controller_name#action_name' do
      specify do
        expect(init_with('people#index').match?(controller)).to be_truthy
      end

      specify do
        expect(init_with('people#show').match?(controller)).to be_falsy
      end

      specify 'supports some actions' do
        expect(init_with('people#show', 'people#index').match?(controller)).to be_truthy
      end

      specify do
        page_contents = init_with {|c| c.controller_name == 'people' }

        expect(page_contents.match?(controller)).to be_truthy
      end
    end

    describe 'hash conditions' do
      let(:controller) { double('controller', params: params.with_indifferent_access) }

      context 'when the condition exactly equals the params' do
        let(:params) { { "controller" => 'users', "action" => 'show' } }
        let(:condition) { { controller: 'users', action: 'show' } }

        specify do
          expect(init_with(condition).match?(controller)).to be_truthy
        end
      end

      context 'when the condition is a sub-hash of the params' do
        let(:params) { { "controller" => 'users', "action" => 'show', "id" => "123" } }
        let(:condition) { { controller: 'users', action: 'show' } }

        specify do
          expect(init_with(condition).match?(controller)).to be_truthy
        end
      end

      context 'when the condition differs with the params' do
        let(:params) { { "controller" => 'users', "action" => 'show' } }
        let(:condition) { { controller: 'users', action: 'index' } }

        specify do
          expect(init_with(condition).match?(controller)).to be_falsy
        end
      end
    end
  end
end
