require 'spec_helper'
require 'progress_handler/reporters/redis_reporter'

describe ProgressHandler::Reporters::RedisReporter do
  setup_reporter_spec(described_class)

  let(:redis) { Redis.new }
  let(:reporter_options) { {redis: redis}.merge(options) }
  let(:options) { {} }

  let(:subject) { progress_handler.reporters[0] }

  it('has the redis configured') { expect(subject.redis).to eq redis }

  context 'when finished' do
    let(:expected_hash) do
      {
          percent_progress: 100.0,
          total_size: items.count,
          progress: items.count,
          time_left: 0.0
      }
    end
    before { progress_handler.each(items) {} }
    it { expect(subject.progress).to eq expected_hash }
    it('set to expire') do
      expect(redis.ttl('progress:Specs')).to be > 0
    end
  end

  describe 'report item progress' do
    before { progress_handler.increment(1) {} }
    context 'when report item notification' do
      let(:options) { { report_item: true } }
      it { expect(subject.progress[:progress]).to eq(1) }
    end
    context 'when dont report each item' do
      it { expect(subject.progress[:progress]).not_to eq(1) }
    end
  end

  describe 'redis path' do
    let(:ph_options) { { name: 'Specs', report_gap: 2, parent: 'rspec' } }
    before { progress_handler.each(items) {} }
    it { expect(redis.hget('progress:rspec:Specs', :progress)).to eq '5' }
  end

  describe 'stop?' do
    context 'when check on report progress' do
      before do
        redis.hset 'progress:Specs', 'stop', true
        progress_handler.each(items) {}
      end
      it { expect(subject.progress[:progress]).to eq 0 }
    end
  end
end