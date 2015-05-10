require 'spec_helper'

describe ProgressHandler do
  let(:items) { 5.times.map &:to_s }
  subject { ProgressHandler.new name: 'Specs', report_gap: 2 }

  it('has name') { expect(subject.name).to eq 'Specs' }
  it('has a report gap') { expect(subject.report_gap).to eq 2 }

  describe '#each' do
    it('yields for each item') { expect {|b| subject.each(items, &b) }.to yield_successive_args(*items) }

    describe 'finished state' do
      before { subject.each(items) {} }

      it { expect(subject.progress).to eq items.size }
      it { expect(subject.percent_progress).to eq 100.0 }
    end

    describe 'observer notification' do
      let(:observer_class) { double }
      let(:observer) { double(:observer, notify_item: nil, notify_progress: nil, stop?: false) }
      before do
        allow(observer_class).to receive(:new).and_return(observer)
        ProgressHandler.configure do |config|
          config.reporters = { observer_class => {} }
        end
      end

      it('has the observer list at #reporters') { expect(subject.reporters).to eq [observer] }
      it('notifies each item') { expect(observer).to receive(:notify_item).exactly(items.count).times }
      it('notifies progress') { expect(observer).to receive(:notify_progress).exactly(3).times }
      after { subject.each(items) {} }

      describe 'observer stop signal' do
        let(:observer) { double(:observer, notify_item: nil, notify_progress: nil, stop?: true) }
        it('notifies each item') { expect(observer).to receive(:notify_item).exactly(1).times }
      end
    end
  end

  describe '#time_left' do
    it do
      subject.total_size = 5
      subject.increment(1) { sleep 1 }
      expect(subject.time_left).to be_within(0.1).of(4)
    end
    it('is undefined right on start') { expect(subject.time_left).to be_nil }
    it('is zero at the end') { subject.each(items) {}; expect(subject.time_left).to eq 0 }
  end
end