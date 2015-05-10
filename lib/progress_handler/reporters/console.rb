class ProgressHandler
  module Reporters
    class Console
      def initialize(pr, _, _)
        @pr = pr
      end

      def notify_item(item)
        show_progress if pr.progress == 1
        print '.'
      end

      def notify_progress
        if pr.progress != pr.total_size
          show_progress
        else
          show_done
        end
      end

      def show_progress
        print "\n#{pr.name}: " if pr.name
        printf "#{pr.progress} / #{pr.total_size} => %3.1f%%, %3.1f minutes to go ",
               pr.percent_progress, pr.time_left / 60.0
      end

      def show_done
        t = Time.now - pr.start_time
        printf "\n#{pr.name}: done. #{pr.total_size} items in %.1f minutes\n", t
      end

      private

      attr_reader :pr
    end
  end
end
