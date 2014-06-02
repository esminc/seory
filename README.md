# Seory

Manage SEO contets in Rails app. based on controller, action and more complex context.

## Installation

Add this line to your application's Gemfile:

    gem 'seory'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seory

## Usage

Specify SEO content as ruby code.  For example, `config/initializers/seory.rb`

```ruby
# Specify SEO content based on `controller#action` rule
match %w[products#popular], {
  title:    'Great products | My Great Site[MGS]'
  desc:     'A lot of greate products'

  keywords: %w[Software Internet Service]

  h1:       'Most popular products'
}

# Can contain dynamic content based on controller using assigned ivar
match 'brands#show' {
  title: -> { assign(:brand).name }
}

# Lookup definition with conntroller context
match ->(controller) { controller.params[:page].to_i == 1 }, {
  keywords: -> do
    search = assign(:search_object)

  end
}

# [TODO] Use custom word part
match %w[products#index] do
  page_name { "#{page_part} Good products") }

  title  :page_name
  h1     :page_name

  desc   { "Page for #{page_name}" }
}

default do
  title  'My Great Service'
  h1     { I18n.t("#{controller_name}.h1", scope: 'label.misc_pages' }
end
```

Then use in your application.
```ruby
# [TODO] nice integration
module ApplicationHelper
  def seory
    @seory ||= Seory::Runtime.new(Seory::Definition.lookup(controller), controller)
  end
end
```

## Contributing

1. Fork it ( https://github.com/esminc/seory/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
