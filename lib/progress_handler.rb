require 'progress_handler/version'
require 'progress_handler/reporters/base'
require 'progress_handler/configuration'

class ProgressHandler
  attr_accessor :name, :report_gap, :total_size
  attr_reader :progress, :reporters, :start_time

  def initialize(options = {})
    @name = options[:name] || SecureRandom.uuid
    @report_gap = options[:report_gap] || 100
    setup_reporters(options)
    reset(options[:total_size])
  end

  def each(items)
    reset(items.count)
    items.each do |item|
      increment(item) { yield item }
      break if stop?
    end
  end

  def increment(item)
    yield
    @progress += 1

    notify_reporters { |o| o.notify_item(item) }

    if (report_gap > 0 and progress % report_gap == 0) || (progress == total_size)
      notify_reporters { |o| o.notify_progress }
    end
  end

  def percent_progress
    100.0 * progress / total_size if total_size
  end

  def time_left
    if total_size && progress > 0
      (total_size - progress) * ((Time.now - @start_time) / progress)
    end
  end

  private

  def setup_reporters(options)
    @reporters = []
    ProgressHandler.configuration.reporters.each do |reporter_class, reporter_options|
      @reporters << reporter_class.new(self, reporter_options, options)
    end
  end

  def reset(total_size)
    @total_size = total_size
    @progress = 0
    @start_time = Time.now
  end

  def notify_reporters(&block)
    @reporters.each {|o| block.call(o) }
  end

  def stop?
    reporters.map(&:stop?).reduce(false) {|result, stop| result || stop}
  end
end
