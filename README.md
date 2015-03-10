# PecoSelector

Select objects with peco.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peco_selector'
```

And then execute:

    $ bundle

## Usage

```
bob    = Object.new
alice  = Object.new
result = PecoSelector.select_from(bob: bob, alice: alice)
result # => [bob]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/peco_selector/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
