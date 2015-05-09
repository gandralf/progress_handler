require 'bundler/setup'
Bundler.setup

require 'progress_reporter'

SPEC_ROOT = File.dirname(__FILE__)

Dir[File.join(SPEC_ROOT, 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
end