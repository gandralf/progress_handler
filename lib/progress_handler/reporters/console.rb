class ProgressHandler
  module Reporters
    class Console < ProgressHandler::Reporters::Base
      def notify_item(_)
        show_progress if progress_handler.progress == 1
        print '.'
      end

      def notify_progress
        if progress_handler.progress != progress_handler.total_size
          show_progress
        else
          show_done
        end
      end

      def show_progress
        print "\n#{progress_handler.name}: " if progress_handler.name
        printf "#{progress_handler.progress} / #{progress_handler.total_size} => %3.1f%%, %3.1f minutes to go ",
               progress_handler.percent_progress, progress_handler.time_left / 60.0
      end

      def show_done
        t = Time.now - progress_handler.start_time
        printf "\n#{progress_handler.name}: done. #{progress_handler.total_size} items in %.1f minutes\n", t
      end

      private

      attr_reader :pr
    end
  end
end
