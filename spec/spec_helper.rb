require 'bundler/setup'
Bundler.setup

require 'progress_handler'

SPEC_ROOT = File.dirname(__FILE__)

Dir[File.join(SPEC_ROOT, 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    ProgressHandler.configure do |pr_config|
      pr_config.reporters = [ ]
    end
  end
end