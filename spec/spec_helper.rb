require 'bundler/setup'
Bundler.setup

require 'progress_reporter'

SPEC_ROOT = File.dirname(__FILE__)

Dir[File.join(SPEC_ROOT, 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    ProgressReporter.configure do |pr_config|
      pr_config.observers = [ ]
    end
  end
end