require 'spec_helper'

describe ProgressReporter do
  describe '#each' do
    let(:items) { 5.times.map &:to_s }
    subject { ProgressReporter.new name: 'Specs', report_gap: 2 }

    it('yields for each item') { expect {|b| subject.each(items, &b) }.to yield_successive_args(*items) }
    it('has name') { expect(subject.name).to eq 'Specs' }
    it('has a report gap') { expect(subject.report_gap).to eq 2 }

    describe 'observer notification' do
      let(:observer) { double(:observer, notify_item: nil, notify_progress: nil) }
      before do
        ProgressReporter.configure do |config|
          config.observers = [ observer ]
        end
      end

      it('notifies each item') { expect(observer).to receive(:notify_item).with(subject).exactly(items.count).times }
      it('notifies progress') { expect(observer).to receive(:notify_progress).with(subject).exactly(2).times }
      after { subject.each(items) {} }
    end
  end
end