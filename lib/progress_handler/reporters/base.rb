class ProgressHandler
  module Reporters
    class Base
      attr_reader :progress_handler, :parent, :options, :ph_options

      def initialize(progress_handler, reporter_options, ph_options)
        @progress_handler = progress_handler
        @parent = ph_options[:parent]
        @options = reporter_options
        @ph_options = ph_options
        @stop = false
      end

      def stop?
        @stop
      end
    end
  end
end
