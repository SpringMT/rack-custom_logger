# Rack::CustomLogger
[![Build Status](https://travis-ci.org/SpringMT/rack-custom_logger.png)](https://travis-ci.org/SpringMT/rack-custom_logger)
[![Coverage Status](https://coveralls.io/repos/SpringMT/rack-custom_logger/badge.png)](https://coveralls.io/r/SpringMT/rack-custom_logger)

* Change rack default logger

## Installation

Add this line to your application's Gemfile:

    gem 'rack-custom_logger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-custom_logger

## Usage

```
use Rack::CustomLogger, DailyLogger.new("#{log_dir}/test")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
