require 'spec_helper'
require 'seory/dsl'

describe Seory::Dsl do
  before do
    Seory::Dsl.describe do
      match 'products#index' do
        title 'My Great Product'
        h1    'Great Product Name'
      end
    end
  end

  subject(:seory) { Seory::Dsl.lookup(controller) }

  context 'at products#index' do
    let(:controller) { double('controller', controller_name: 'products', action_name: 'index') }

    specify { expect(seory.title).to eq 'My Great Product' }
    specify { expect(seory.h1).to eq 'Great Product Name' }
  end
end
