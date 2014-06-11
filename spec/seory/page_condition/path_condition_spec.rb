require 'spec_helper'
require 'seory/page_condition/path_condition'

describe Seory::PageCondition::PathCondition do
  let(:controller) { double('controller') }
  let(:path_condition) do
    Seory::PageCondition::PathCondition.new('/users/alice')
  end

  context 'Accessed to /users/alice (controller: users, action: show, id: alice)' do
    before do
      allow(controller).to receive_message_chain(:request, :fullpath) { '/users/alice' }
    end

    specify { expect(path_condition.match?(controller)).to be_truthy }
  end

  context 'Accessed to /users/bob (controller: users, action: show, id: bob)' do
    before do
      allow(controller).to receive_message_chain(:request, :fullpath) { '/users/bob' }
    end

    specify { expect(path_condition.match?(controller)).to be_falsy }
  end
end
