require 'progress_handler/reporters/console'

class ProgressHandler
  class << self
    attr_writer :configuration
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.configuration
    @configuration ||= begin
      config = ProgressHandler::Configuration.new
      config.reporters = {
          ProgressHandler::Reporters::Console => {}
      }
      config
    end
  end

  class Configuration
    attr_accessor :reporters
  end
end