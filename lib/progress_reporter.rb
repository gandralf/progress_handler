require 'progress_reporter/version'
require 'progress_reporter/configuration'

class ProgressReporter
  attr_accessor :name, :report_gap
  attr_reader :count, :progress, :total_size

  def initialize(options)
    @name = options[:name]
    @report_gap = options[:report_gap]
  end

  def each(items)
    @progress = 0
    @total_size = items.count
    @count = 0

    items.each do |item|
      yield item
      @count += 1

      notify_observers { |o| o.notify_item(self) }

      if report_gap > 0 and count % report_gap == 0
        @progress = 100.0 * count / total_size
        notify_observers { |o| o.notify_progress(self) }
      end
    end
  end

  def notify_observers(&block)
    ProgressReporter.configuration.observers.each {|o| block.call(o) }
  end
end
