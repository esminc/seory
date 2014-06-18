require 'spec_helper'
require 'seory/repository'
require 'seory/dsl/descriptor'

describe Seory::Repository do
  describe '.extract_label_from_trace' do
    let(:label) do
      begin
        raise
      rescue => ex
        Seory::Repository.extract_label_from_trace(ex.backtrace)
      end
    end

    specify { expect(label).to eq __FILE__ }
  end

  context 'has 2 page groups: users & products' do
    let(:repository) { Seory::Repository.new }

    def page_group(name, title = name)
      Seory::Dsl::Descriptor.new(name, repository).describe do
        match(slug("#{name}#show")) { title title }
      end
    end

    def title_for(*args)
      repository.lookup(controller_double(*args)).title
    end

    before do
      repository << page_group('users')
      repository << page_group('products')
    end

    specify 'lookup valid page over page_groups' do
      expect(title_for('users#show', id: 42)).to eq 'users'
      expect(title_for('products#show', id: 42)).to eq 'products'
    end

    context 'overrides same name group' do
      before do
        repository << page_group('users', 'other users')
      end

      specify 'after one should be used' do
        expect(title_for('users#show', id: 42)).to eq 'other users'
      end
    end
  end
end
