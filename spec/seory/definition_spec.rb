require 'spec_helper'
require 'seory/definition'

describe Seory::Definition do
  let(:seory_def) do
    Seory::Definition.new
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
