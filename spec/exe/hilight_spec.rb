require 'spec_helper'

require 'open3'

RSpec.describe "exe/hilight" do
  let(:subject) { (Open3.capture2e('hilight rspec -h')) }
  let(:output) { subject[0] }
  let(:pid) { subject[1] }

  it "is expected to have an exit code of zero" do
    expect(pid).to be_success
  end

  context "with no supplied command" do
    it "is expected to capture STDIN"
  end

  context "with a option flag before the supplied command" do
    it "is expected to parse the option"
  end

  context "with a option flag after the supplied command" do
    it "is expected to pass the option to the supplied command"
  end

  describe "optional flags" do
    context "when the flag is -h or --help" do
      it "is expected to display help"
    end
  end
end
