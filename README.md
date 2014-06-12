# seory

Manage SEO contents in Rails app. based on controller, action and more complex context.

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
match *%w[products#popular products#new_release] do
  title            'Great products | My Great Site[MGS]'
  meta_description 'A lot of greate products'

  meta_keywords    %w[Software Internet Service].join(',')

  h1               'Most popular products'
end

# Can contain dynamic content based on controller using assigned ivar
match slug('brands#show') do
  title { assigns(:brand).name }
end

# Match with request fullpath
match path('/products/special-product') do
  title 'Special Product Detail'
end

# Custom lookup rule with controller
match(->(controller) { controller.params[:page].to_i == 1 }) do
  meta_keywords do
    search = assigns(:search_object)

    # do something
  end
end

# Use custom word part
match slug('products#index') do
  misc(:page_name) { "#{controller.params[:page].to_i} page | Good products") }

  title :page_name
  h1    :page_name

  meta_description { "Page for #{page_name}" }
}

default do
  title 'My Great Service'
  h1    { I18n.t("#{controller_name}.h1", scope: 'label.misc_pages' }
end
```

Then we can use seory in your application.[TODO]
```ruby
module ApplicationHelper

  # provides seory() method,
  # which returns Seory::Runtime object with configured
  include Seory::Helper
end
```

```haml
%html
  %head
    %title= seory.title
    ...
  %body
    %h1= seory.h1
```

## Contributing

1. Fork it ( https://github.com/esminc/seory/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Thanks

- @libkazz: Specification adviser
- @darashi: God father

