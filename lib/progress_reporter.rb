require 'progress_reporter/version'
require 'progress_reporter/configuration'

class ProgressReporter
  attr_accessor :name, :report_gap, :total_size
  attr_reader :count, :progress

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
    @count += 1

    notify_observers { |o| o.notify_item(self) }

    if report_gap > 0 and count % report_gap == 0
      @progress = 100.0 * count / total_size
      notify_observers { |o| o.notify_progress(self) }
    end
  end

  def time_left
    if total_size && count > 0
      (total_size - count) * ((Time.now - @start_time) / count)
    end
  end

  private

  def reset(total_size)
    @progress = 0
    @total_size = total_size
    @count = 0
    @start_time = Time.now
  end

  def notify_observers(&block)
    ProgressReporter.configuration.observers.each {|o| block.call(o) }
  end
end
