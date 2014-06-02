require 'spec_helper'
require 'seory/runtime'

describe Seory::Runtime do
  let(:seory) do
    Seory::Runtime.new(definition, controller)
  end

  let(:controller) do
    double('controller').tap do |c|

    end
  end

  let(:definition) do
    double('definition').tap do |d|
      allow(d).to receive(:definition_for).with(:title) { 'A title' }
    end
  end

  describe '#title' do
    specify { expect(seory.title).to eq 'A title' }
  end
end
