require 'spec_helper'
require 'progress_handler/reporters/console'

describe ProgressHandler::Reporters::Console do
  setup_reporter_spec(described_class)

  it { progress_handler.each(items) {} }
end