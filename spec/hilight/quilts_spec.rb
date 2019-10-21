require 'spec_helper'

RSpec.describe Hilight::Quilts do
  before do
    allow(Dir).to receive(:glob).and_return(['filename.rb'])
    allow(File).to receive(:exist?).with('filename.rb').and_return(true)
    allow(File).to receive(:read).with('filename.rb').and_return(content)
    subject
  end

  let(:content) do
    '{
      fabric: {
        match_pattern: "help",
        regexps: [/<?argument>.*/]
      },
      pattern: { argument: "33" }
     }'
  end

  it { is_expected.to have_attributes(collection: a_kind_of(Array).or(be_nil)) }

  it { is_expected.to respond_to(:match_quilt).with(1).arguments }
  it { is_expected.to respond_to(:load_quilts_from_gem).with(0).arguments }

  describe "#load_quilts_from_gem" do
    let(:subject) { described_class.load_quilts_from_gem }

    it "is expected to find all quilts from data/quilts" do
      expect(Dir).to have_received(:glob)
    end

    it "is expected to read each file from data/quilts" do
      expect(File).to have_received(:read)
    end
  end

  describe "#match_quilt" do
    let(:subject) { described_class.match_quilt('help') }

    before { described_class.load_quilts_from_gem }

    it "is expected to return the quilt that matches the supplied pattern" do
      expect(subject).to be_a_kind_of Hilight::Quilt
    end
  end
end
