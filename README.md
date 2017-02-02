# Rack::JsonParser

[![Travis CI](https://travis-ci.org/meso-unimpressed/rack-json_parser.svg?branch=master)](https://travis-ci.org/meso-unimpressed/rack-json_parser)
[![Code Climate](https://codeclimate.com/github/meso-unimpressed/rack-json_parser/badges/gpa.svg)](https://codeclimate.com/github/meso-unimpressed/rack-json_parser)
[![Test Coverage](https://codeclimate.com/github/meso-unimpressed/rack-json_parser/badges/coverage.svg)](https://codeclimate.com/github/meso-unimpressed/rack-json_parser/coverage)
[![Issue Count](https://codeclimate.com/github/meso-unimpressed/rack-json_parser/badges/issue_count.svg)](https://codeclimate.com/github/meso-unimpressed/rack-json_parser)

A simple Rack middleware for parsing json from request bodies

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-json_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-json_parser

## Usage

```ruby
# config.ru

use MyErrorHandler
use Rack::JSONParser, content_type: 'application/json'
run MyApp
```

The named param `content_type` is optional and defaults to `application/json`
you can use arrays, regexes or arrays of regexes here. Anything really which
will evaluate to true when using the case operator `===` against the request
content type.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
[meso-unimpressed/rack-json_parser](https://github.com/meso-unimpressed/rack-json_parser).
