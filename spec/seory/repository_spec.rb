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

  def title_for(*args)
    repository.lookup(controller_double(*args)).title
  end

  def page_group(name, title = name)
    describe_page_group(name) do
      match(slug("#{name}#show")) { title title }
    end
  end

  def describe_page_group(name, &block)
    Seory::Dsl::Descriptor.new(name, repository).describe(&block)
  end

  context 'has 2 page groups: users & products' do
    let(:repository) { Seory::Repository.new }

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

    context 'match controller by PageGroup#name sorted' do
      before do
        repository << (
          Seory::Dsl::Descriptor.new('aaa', repository).describe do
            match(params(controller: 'users')) { title 'defined after, match ahead' }
          end
        )
      end

      specify do
        expect(title_for('users#show', id: 42)).to eq 'defined after, match ahead'
      end
    end
  end

  describe 'default fallback' do
    let(:repository) { Seory::Repository.new }

    context 'default is used from any page group' do
      before do
        repository << page_group('users')
        repository << describe_page_group('default') { default { title 'default title' } }
      end

      specify do
        expect(title_for('hoge#foo')).to eq 'default title'
      end

      specify 'default can be specified from only one page group' do
        expect {
          repository << describe_page_group('duplicate default') { default { title 'duplicate default' } }
        }.to raise_error(Seory::DuplicateDefault)
      end
    end
  end
end
