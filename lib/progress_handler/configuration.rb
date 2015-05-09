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
      config.reporters = []
      config
    end
  end

  class Configuration
    attr_accessor :reporters
  end
end