require 'redis'

class ProgressHandler
  module Reporters
    class RedisReporter < ProgressHandler::Reporters::Base
      DEFAULT_EXPIRES = 3600
      attr_reader :redis

      def initialize(progress_handler, reporter_options, ph_options)
        super
        @redis = reporter_options.fetch(:redis)
        @report_item = reporter_options[:report_item]
        @expires = reporter_options.fetch(:expires, DEFAULT_EXPIRES)

        notify_progress
        redis.hdel redis_key, 'stop'
      end

      def notify_item(_)
        if @report_item
          notify_progress
          check_stop_flag
        end
      end

      def notify_progress
        progress = {
            percent_progress: progress_handler.percent_progress,
            total_size: progress_handler.total_size,
            progress: progress_handler.progress,
            time_left: progress_handler.time_left
        }

        redis.hmset redis_key, *progress
        check_stop_flag
        set_expire if done?
      end

      def progress
        h = redis.hgetall redis_key
        result = {}
        %i(percent_progress time_left).each do |k|
          result[k] = h[k.to_s].to_f if h[k.to_s]
        end
        %i(total_size progress).each do |k|
          result[k] = h[k.to_s].to_i if h[k.to_s]
        end

        result
      end

      private

      def set_expire
        redis.expire redis_key, @expires
      end

      def done?
        progress_handler.total_size && (progress_handler.progress == progress_handler.total_size)
      end

      def check_stop_flag
        @stop = redis.hget redis_key, 'stop'
      end

      def redis_key
        if parent
          "progress:#{parent}:#{progress_handler.name}"
        else
          "progress:#{progress_handler.name}"
        end
      end
    end
  end
end