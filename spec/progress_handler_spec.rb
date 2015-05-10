require 'spec_helper'

describe ProgressHandler do
  let(:items) { 5.times.map &:to_s }
  subject { ProgressHandler.new name: 'Specs', report_gap: 2 }

  it('has name') { expect(subject.name).to eq 'Specs' }
  it('has a report gap') { expect(subject.report_gap).to eq 2 }

  describe '#each' do
    it('yields for each item') { expect {|b| subject.each(items, &b) }.to yield_successive_args(*items) }

    describe 'observer notification' do
      let(:observer_class) { double }
      let(:observer) { double(:observer, notify_item: nil, notify_progress: nil) }
      before do
        expect(observer_class).to receive(:new).and_return(observer)
        ProgressHandler.configure do |config|
          config.reporters = { observer_class => {} }
        end
      end

      it('notifies each item') { expect(observer).to receive(:notify_item).with(subject).exactly(items.count).times }
      it('notifies progress') { expect(observer).to receive(:notify_progress).with(subject).exactly(2).times }
      after { subject.each(items) {} }
    end
  end

  describe '#time_left' do
    it do
      subject.total_size = 5
      subject.increment { sleep 1 }
      expect(subject.time_left).to be_within(0.1).of(4)
    end
    it('is undefined right on start') { expect(subject.time_left).to be_nil }
    it('is zero at the end') { subject.each(items) {}; expect(subject.time_left).to eq 0 }
  end
end