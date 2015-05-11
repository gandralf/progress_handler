class ProgressHandler
  module Reporters
    class Console < ProgressHandler::Reporters::Base
      def notify_item(_)
        show_progress if progress_handler.progress == 1
        print '.' unless logger
      end

      def notify_progress
        if progress_handler.progress != progress_handler.total_size
          show_progress
        else
          show_done
        end
      end

      def show_progress
        msg = ''
        msg << "\n" unless logger
        msg << "#{name}: " if name
        msg << sprintf("#{progress_handler.progress} / #{progress_handler.total_size} => %3.1f%%, %3.1f minutes to go ",
               progress_handler.percent_progress, progress_handler.time_left / 60.0)
        write(msg)
      end

      def show_done
        t = (Time.now - progress_handler.start_time) / 60
        msg = sprintf("#{name}: done. #{progress_handler.total_size} items in %.1f minutes", t)
        msg = "\n#{msg}\n" unless logger
        write msg
      end

      private

      def name
        if ph_options[:parent]
          "#{ph_options[:parent]}:#{progress_handler.name}"
        else
          progress_handler.name
        end
      end

      def write(s)
        if logger
          logger.info(s)
        else
          print s
        end
      end

      def logger
        options[:logger]
      end
    end
  end
end
