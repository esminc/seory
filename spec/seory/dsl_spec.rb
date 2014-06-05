require 'spec_helper'
require 'seory/dsl'

describe Seory::Dsl do
  let(:seory_class) { Object.new.extend(Seory::Dsl) }
  before do
    seory_class.describe do
      match 'products#index' do
        title 'My Great Product'
        h1    'Great Product Name'

        misc :option, 'static optional val'
      end

      default do
        title 'Misc site'
        h1    { controller.controller_name.upcase }

        misc(:option) { "dynamic option name at #{controller.controller_name}" }
      end
    end
  end

  subject(:seory) { seory_class.lookup(controller) }

  context 'at products#index' do
    let(:controller) { double('controller', controller_name: 'products', action_name: 'index') }

    specify { expect(seory.title).to eq 'My Great Product' }
    specify { expect(seory.h1).to eq 'Great Product Name' }
    specify { expect(seory.misc(:option)).to eq 'static optional val' }
  end

  context 'at misc#show' do
    let(:controller) { double('controller', controller_name: 'misc', action_name: 'show') }

    specify { expect(seory.h1).to eq 'MISC' }
    specify { expect(seory.misc(:option)).to eq 'dynamic option name at misc' }
  end
end
