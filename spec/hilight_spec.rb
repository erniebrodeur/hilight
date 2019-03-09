require 'spec_helper'

RSpec.describe Hilight do
  let(:regexp) { /(?<green>'.*')|(?<blue>".*")/ }
  let(:replacement) { '\k<green>\k<blue>' }
  let(:string) { "here is 'an inline comment' and \"another\"" }

  it { is_expected.to respond_to(:load).with(1).arguments }

  it "is expected to have a version number" do
    expect(Hilight::VERSION).not_to be nil
  end

  describe "#load" do
    let(:filename) { 'a_file.rb' }

    before do
      allow(File).to receive(:exist?).and_call_original
      allow(Kernel).to receive(:load).with(filename).and_return nil
    end

    specify do
      allow(File).to receive(:exist?).with(filename).and_return true
      described_class.load(filename)
      expect(Kernel).to have_received(:load).with filename
    end

    context "when the filename does not exist, Kernel" do
      let(:expected_filename) { "#{Dir.home}/.config/hilight/patterns/#{filename}" }

      before { allow(File).to receive(:exist?).with(filename).and_return false }

      specify do
        allow(Kernel).to receive(:load).with expected_filename
        described_class.load(filename)
        expect(Kernel).to have_received(:load).with expected_filename
      end
    end
  end

  describe Hilight::Filter do
    let(:patterns) { Hilight::Pattern[regexp, replacement] }
    let(:cmd) { /not_a_match/ }

    it { is_expected.to respond_to(:match?).with(1).arguments}

    describe "#match?" do
      let(:subject) { described_class[cmd, patterns].match? 'some command'}

      it { is_expected.to be false }

      context "when the string matches the cmd pattern" do
        let(:subject) { described_class[/some command/, patterns].match? 'some command'}

        it { is_expected.to be true }
      end
    end
  end

  describe Hilight::Filters do
    it { is_expected.to respond_to(:find).with(1).arguments}

    describe "#find" do
      it "is expected to return the first entry that matches the argument string"
    end

    describe "#run" do
      it "is expected to find a filter ARGV"
      it "is expected to execute ARGV"
      it "is expected to return the hilighted output of patterns"
      it "is expected to return the exitstatus from argv"

      context "when it cannot find a matching filter" do
        it "is expected to return default"
      end
    end
  end

  describe Hilight::Pattern do
    it { is_expected.to have_attributes(regexp: a_kind_of(Regexp).or(be_nil)) }
    it { is_expected.to have_attributes(replacement: a_kind_of(String).or(be_nil)) }
    it { is_expected.to respond_to(:output).with(1).arguments }

    describe "#output" do
      let(:subject) { described_class[regexp, replacement].output(string) }

      it { is_expected.to be_a_kind_of String }

      it "is expected to include ansi color codes" do
        expect(subject).to include(Term::ANSIColor.blue)
      end

      context "when no replacement is found" do
        let(:string) { 'not a matching string' }

        it "is expected to return the original string" do
          expect(subject).to eq string
        end
      end
    end
  end

  describe Hilight::Patterns do
    it { is_expected.to have_attributes(patterns: a_kind_of(Array).or(be_nil)) }

    describe "#output" do
      let(:pattern) { Hilight::Pattern[regexp, replacement] }
      let(:subject) { described_class[[pattern]].output(string) }

      it "is expected to run each pattern over the input string" do
        expect(subject).to include(Term::ANSIColor.blue).and(include(Term::ANSIColor.green))
      end

      it { is_expected.to be_a_kind_of String }
    end
  end
end
