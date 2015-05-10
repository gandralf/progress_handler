# Progress Handler

Useful tool to register, follow or even interrupt the progress of a background job 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'progress_handler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install progress_handler

## Usage

Very simple progress handler, to see reports or pause/resume the processing itself.

    ➜  progress_handler git:(master) bin/console
    [1] pry(main)> it = 120.times
    => #<Enumerator: ...>
    [2] pry(main)> ProgressHandler.new(name: 'Hello', report_gap: 50).each(it) {|item| sleep 0.5 }
    
    Hello: 1 / 120 => 0.8%, 1.0 minutes to go ..................................................
    Hello: 50 / 120 => 41.7%, 0.6 minutes to go ..................................................
    Hello: 100 / 120 => 83.3%, 0.2 minutes to go ....................
    Hello: done. 120 items in 1.0 minutes
    => 120

### Reporters

Reporters show what is going on. This gem have the following built-in reporters:
- A console reporter (set up by default)
- A redis reporter

To create or use a reporter, you must configure it, like:

```ruby
require 'progress_handler/reporters/redis_reporter'

#...
ProgressHandler.configure do |config|
  config.reporters = {
    ProgressHandler::Reporters::RedisReporter => {
      redis: Redis.new
    }
  }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt 
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the 
version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/gandralf/progress_handler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
