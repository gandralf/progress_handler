class ProgressHandler
  module Reporters
    class Console
      def notify_item(pr)
        show_progress(pr) if pr.progress == 1
        print '.'
      end

      def notify_progress(pr)
        show_progress(pr)
      end

      def show_progress(pr)
        print "\n#{pr.name}: " if pr.name
        printf "#{pr.progress} / #{pr.total_size} => %3.1f%%, %3.1f minutes to go ",
               pr.percent_progress, pr.time_left / 60.0
      end
    end
  end
end
