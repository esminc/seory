require 'spec_helper'
require 'seory/runtime'

describe Seory::Runtime do
  let(:seory) do
    Seory::Runtime.new(definition, controller)
  end

  let(:controller) { double('controller') }
  let(:definition) { double('definition') }

  context 'static content' do
    before do
      allow(definition).to receive(:definition_for).with(:title) { 'A title' }
    end

    describe '#title' do
      specify { expect(seory.title).to eq 'A title' }
    end
  end
end
