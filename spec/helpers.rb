module Helpers
  def setup_reporter_spec(reporter)
    before { ProgressHandler.configure {|config| config.reporters = {reporter => reporter_options} } }
    let(:reporter_options) { {} }
    let(:items) { 5.times.map &:to_s }
    let(:progress_handler) { ProgressHandler.new name: 'Specs', report_gap: 2 }
  end
end
