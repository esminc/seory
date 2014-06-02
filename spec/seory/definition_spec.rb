require 'spec_helper'
require 'seory/definition'

describe Seory::Definition do
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
    let(:controller) { double('controller', controller_name: 'people', action_name: 'index') }

    specify '`:default` matches everything (stacked in bottom)' do
      expect(Seory::Definition.new(:default)).to be_match(double('something'))
    end

    describe 'controller_name#action_name' do
      specify do
        expect(Seory::Definition.new('people#index').match?(controller)).to be_truthy
      end

      specify do
        expect(Seory::Definition.new('people#show').match?(controller)).to be_falsy
      end
    end
  end
end
