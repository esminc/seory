require 'spec_helper'
require 'seory/definition'

describe Seory::Definition do
  specify 'cant define without condition' do
    expect { Seory::Definition.new }.to raise_error(Seory::EmptyCondition)
  end

  context 'content definition' do
    let(:seory_def) do
      Seory::Definition.new(:default)
    end

    context 'define static content' do
      before do
        seory_def.define(:title, 'A title')
      end

      specify { expect(seory_def.definition_for(:title)).to eq 'A title' }
    end

    context 'define dynamic content' do
      before do
        seory_def.define(:title) { 'A title' }
      end

      specify { expect(seory_def.definition_for(:title).call).to eq 'A title' }
    end
  end

  context 'lookup' do
    def init_with(*args, &block)
      Seory::Definition.new(*args, &block)
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
        definition = init_with {|c| c.controller_name == 'people' }

        expect(definition.match?(controller)).to be_truthy
      end
    end
  end
end
