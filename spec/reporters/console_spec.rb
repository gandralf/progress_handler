require 'spec_helper'
require 'progress_handler/reporters/console'

describe ProgressHandler::Reporters::Console do
  before { ProgressHandler.configure {|config| config.reporters = [described_class.new] } }

  let(:items) { 5.times.map &:to_s }
  let(:pr) { ProgressHandler.new name: 'Specs', report_gap: 2 }

  it { pr.each(items) {} }
end