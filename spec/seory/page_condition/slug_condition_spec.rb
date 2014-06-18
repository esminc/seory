require 'spec_helper'
require 'seory/page_condition/slug_condition'

describe Seory::Condition::Slug do
  context 'with nested controller slug' do
    let(:controller) do
      double('controller', {
        controller_name: 'products',
        controller_path: 'contents/products',
        action_name:     'index'
      })
    end
    let(:slug_condition) { Seory::Condition::Slug.new('contents/products#index') }

    specify { expect(slug_condition.match?(controller)).to be_truthy }
  end
end

