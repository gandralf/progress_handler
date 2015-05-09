class ProgressReporter
  class << self
    attr_writer :configuration
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.configuration
    @configuration ||= begin
      config = ProgressReporter::Configuration.new
      config.observers = []
      config
    end
  end

  class Configuration
    attr_accessor :observers
  end
end