class ProgressHandler
  module Reporters
    class Console
      def initialize(_, _)
      end

      def notify_item(pr)
        show_progress(pr) if pr.progress == 1
        print '.'
      end

      def notify_progress(pr)
        if pr.progress != pr.total_size
          show_progress(pr)
        else
          show_done(pr)
        end
      end

      def show_progress(pr)
        print "\n#{pr.name}: " if pr.name
        printf "#{pr.progress} / #{pr.total_size} => %3.1f%%, %3.1f minutes to go ",
               pr.percent_progress, pr.time_left / 60.0
      end

      def show_done(pr)
        t = Time.now - pr.start_time
        printf "\n#{pr.name}: done. #{pr.total_size} items in %.1f minutes\n", t
      end
    end
  end
end
