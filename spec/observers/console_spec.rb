require 'spec_helper'
require 'progress_reporter/observers/console'

describe ProgressReporter::Observers::Console do
  before { ProgressReporter.configure {|config| config.observers = [described_class.new] } }

  let(:items) { 5.times.map &:to_s }
  let(:pr) { ProgressReporter.new name: 'Specs', report_gap: 2 }

  it { pr.each(items) {} }
end