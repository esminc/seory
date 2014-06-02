require 'spec_helper'
require 'seory/runtime'
require 'seory/definition'

describe Seory::Runtime do
  let(:seory) do
    Seory::Runtime.new(definition, controller)
  end

  let(:controller) { double('controller') }
  let(:definition) { Seory::Definition.new }

  context 'static content' do
    before do
      definition.define(:title, 'A title')
      definition.define(:h1,    'Most importatnt HEADER 1')
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

      definition.define(:title) { "#{action_name.upcase} | My Site" }
    end

    describe '#titie' do
      specify { expect(seory.title).to eq 'EDIT | My Site' }
    end
  end
end
