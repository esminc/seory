require 'spec_helper'
require 'seory/helper'

describe Seory::Helper do
  describe '#module build dynamic helper module' do
    subject(:helper) do
      Seory::Helper.new do
        def some_method
          :some_method
        end
      end
    end
    let(:runtime) { Object.new }

    before do
      helper.apply!(runtime)
    end

    specify 'can call helper method' do
      expect(runtime.some_method).to eq :some_method
    end
  end

  describe '.rails_helper_methods defines shortcuts to rails helper method' do
    subject(:helper) do
      Seory::Helper.new do
        rails_helper_methods :rails_method
      end
    end
    let(:runtime) { double('runtime') }

    before do
      expect(runtime).to receive_message_chain(:helper, :rails_method) { :rails_method }
      helper.apply!(runtime)
    end

    specify 'can call helper method' do
      expect(runtime.rails_method).to eq :rails_method
    end
  end
end

