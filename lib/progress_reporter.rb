require 'progress_reporter/version'
require 'progress_reporter/configuration'

class ProgressReporter
  attr_accessor :name, :report_gap, :total_size
  attr_reader :progress

  def initialize(options)
    @name = options[:name]
    @report_gap = options[:report_gap]
    reset(options[:total_size])
  end

  def each(items)
    reset(items.count)
    items.each do |item|
      increment { yield item }
    end
  end

  def increment
    yield
    @progress += 1

    notify_observers { |o| o.notify_item(self) }

    if report_gap > 0 and progress % report_gap == 0
      notify_observers { |o| o.notify_progress(self) }
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

  def reset(total_size)
    @total_size = total_size
    @progress = 0
    @start_time = Time.now
  end

  def notify_observers(&block)
    ProgressReporter.configuration.observers.each {|o| block.call(o) }
  end
end
