require 'spec_helper'
require 'logger'
require 'progress_handler/reporters/console'

describe ProgressHandler::Reporters::Console do
  setup_reporter_spec(described_class)

  it { progress_handler.each(items) {} }

  context 'configure using a logger' do
    let(:logger) { Logger.new(STDOUT) }
    let(:reporter_options) { {logger: logger} }
    it do
      [
          'Specs: 1 / 5 => 20.0%, 0.0 minutes to go ',
          'Specs: 2 / 5 => 40.0%, 0.0 minutes to go ',
          'Specs: 4 / 5 => 80.0%, 0.0 minutes to go ',
          'Specs: done. 5 items in 0.0 minutes'
      ].each do |msg|
        expect(logger).to receive(:info).with(msg)
      end
    end
    after { progress_handler.each(items) {} }
  end
end