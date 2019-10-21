require 'spec_helper'

require 'open3'

RSpec.describe "exe/hilight" do # rubocop: disable RSpec/DescribeClass
  let(:subject) { Open3.capture2e('hilight bundle --help') }
  let(:output) { subject[0] }
  let(:pid) { subject[1] }

  it "is expected to have an exit code of zero" do
    expect(pid).to be_success
  end

  context "with no supplied command" do
    let(:subject) { Open3.capture2e('hilight') }

    it "is expected to capture STDIN" do
      expect(output).to eq ''
    end
  end

  context "with a option flag before the supplied command" do
    let(:subject) { Open3.capture2e('hilight -h rspec') }

    it "is expected to parse the option" do
      expect(output).to match(/Usage: hilight/)
    end
  end

  context "with a option flag after the supplied command" do
    let(:subject) { Open3.capture2e('hilight rspec -h') }

    it "is expected to pass the option to the supplied command" do
      expect(output).to match(/rspec/)
    end
  end

  describe "optional flags" do
    context "when the flag is -h or --help" do
      let(:subject) { Open3.capture2e('hilight -h rspec') }

      it "is expected to display help" do
        expect(output).to match(/Usage: hilight/)
      end
    end
  end
end
