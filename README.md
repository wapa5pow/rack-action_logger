# Rack::ActionLogger

[![CircleCI](https://circleci.com/gh/wapa5pow/rack-action_logger.svg?style=shield)](https://circleci.com/gh/wapa5pow/rack-action_logger)
[![Gem Version](https://badge.fury.io/rb/rack-action_logger.svg)](https://badge.fury.io/rb/rack-action_logger)
[![Code Climate](https://codeclimate.com/github/wapa5pow/rack-action_logger/badges/gpa.svg)](https://codeclimate.com/github/wapa5pow/rack-action_logger)

**Rack::ActionLogger** is a tool to collect user action logs via fluentd, Rails.logger or any custome logger.

It is intended to collect user request log, action log and any other custome logs.

**Rails 4 or Rails 5** is required to use it.

## Sample Logs

### Request log

```json
{
  "message": {
    "path": "/",
    "method": "GET",
    "params": {
      "password": "[FILTERED]"
    },
    "request_headers": {
      "HTTP_VERSION": "HTTP/1.1",
      "HTTP_HOST": "localhost:3000",
      "HTTP_CONNECTION": "keep-alive",
      "HTTP_UPGRADE_INSECURE_REQUESTS": "1",
      "HTTP_USER_AGENT": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36",
      "HTTP_ACCEPT": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "HTTP_ACCEPT_ENCODING": "gzip, deflate, sdch, br",
      "HTTP_ACCEPT_LANGUAGE": "ja,en-US;q=0.8,en;q=0.6",
      "HTTP_COOKIE": "xxx"
    },
    "status_code": 200,
    "remote_ip": "127.0.0.1",
    "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36",
    "device": "pc",
    "os": "Mac OSX",
    "browser": "Chrome",
    "browser_version": "54.0.2840.98",
    "request_id": "150a6ac9-0fd9-4a23-a313-d18da1e35911",
    "response_headers": {
      "X-Frame-Options": "SAMEORIGIN",
      "X-XSS-Protection": "1; mode=block",
      "X-Content-Type-Options": "nosniff",
      "Content-Type": "text/html; charset=utf-8"
    },
    "response_json_body": {
    },
    "tag": "action.rack",
    "user_id": 123
  }
}
```

### Append log

```json
{
  "message": {
    "request_id": "150a6ac9-0fd9-4a23-a313-d18da1e35911",
    "value": "with_tag",
    "tag": "action.activities"
  }
}
```

Under example folder, there are sample Rails applications to see how these sample logs are created.

### Model log

```json
{
  "message": {
    "user_id": null,
    "request_id": "5aae4cc6-125b-4049-b555-502d6968e041",
    "_method": "update",
    "_after:updated_at": "2016-11-18 18:40:15 +0900",
    "_before:updated_at": "2016-11-18 18:33:56 +0900",
    "_after:views": 96,
    "_before:views": 95,
    "tag": "action.model_articles"
  },
  "tag": "action.model_articles"
}
```

## Installation

Add this line to your rails application's Gemfile:

```ruby
gem 'rack-action_logger'
gem 'fluent-logger'
```

And then execute:

```
bundle
```

Then, add Rack::ActionLogger as middleware to config/application.rb.

```ruby
config.middleware.use Rack::ActionLogger
```

### Setup Initializations

Under config/initializers, add the following files.

#### fluent_logger.rb

```ruby
Fluent::Logger::FluentLogger.open
```

#### rack-action_logger.rb

```ruby
Rack::ActionLogger.configure do |config|
  config.emit_adapter = Rack::ActionLogger::EmitAdapter::FluentAdapter
  config.wrap_key = :message
  config.logger = Rails.logger
  config.filters = Rails.application.config.filter_parameters
end
```

If wrap_key is nil, the out put does not have parent key of wrap_key.

## Usage

### Enable Request Log

Request log is automatically enabled

Request can be customized by creating new class for rack_metrics configuration.

### Add Append Log

Add the following code to any code on any times.

```ruby
Rack::ActionLogger::Container.add_append_log({ value: 'ok' }, 'activities')
```

### Add Model Logger

Add the folloing line to ```config/initializers/rack-action_logger.rb``` at the end of line.

```
ActiveRecord::Base.send(:include, Rack::ActionLog::ActiveRecordExtension)
```

### Override log attributes

Overriden attributes are added to both request and append logs.

```ruby
Rack::ActionLogger::Container.merge_attributes({ user_id: 123 })
```

The append log is overrided by user_id attribute.

```json
{
  "message": {
    "request_id": "150a6ac9-0fd9-4a23-a313-d18da1e35911",
    "value": "with_tag",
    "uer_id": 123,
    "tag": "action.activities"
  }
}
```

### Logs out of request

If Rails app uses background job system like sidekiq, exported context (e.g. log attributes and request_id) can be passed to the job.

For example, a worker is the following.

```ruby
class TestWorker < ApplicationController
  include Sidekiq::Worker
  sidekiq_options queue: :test, retry: 5

  def perform(title, context)
    Rack::ActionLogger::Emitter.new.emit(context) do
      Rack::ActionLogger::Container.add_append_log({ title: title }, 'worker')
      p 'work: title=' + title
    end
  end

end
```

To call the worker task, the app should call like the following.

```ruby
action_log_context = Rack::ActionLogger::Container.export
TestWorker.perform_async('Worker Job', action_log_context)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wapa5pow/rack-action_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

