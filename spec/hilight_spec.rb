require 'spec_helper'

RSpec.describe Hilight do
  let(:expected_result) { expect(subject.call) } #rubocop:disable all
  let(:regexp) { /(?<green>'.*')|(?<blue>".*")/ }
  let(:substitution) { '\k<green>\k<blue>' }
  let(:result) { subject.call }
  let(:string) { "here is 'an inline comment' and \"another\", with a :symbol" }

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

  describe Hilight::Pattern do
    it { is_expected.to have_attributes(regexp: a_kind_of(Regexp).or(be_nil)) }
    it { is_expected.to have_attributes(substitution: a_kind_of(String).or(be_nil)) }
    it { is_expected.to respond_to(:transform).with(1).arguments }
    it { is_expected.to respond_to(:match?).with(1).arguments }

    Hilight::Pattern.define_method(:transform_stream) { |_io| "" }

    describe "#match?" do
      let(:subject) { Hilight::Pattern[regexp, substitution].match? 'string' }

      it { is_expected.to return_falsey }

      context "when the regexp matches string" do
        let(:subject) { Hilight::Pattern[regexp, substitution].match? string }

        it { is_expected.to return_truthy }
      end
    end

    describe "#transform" do
      let(:subject) { proc { Hilight::Pattern[regexp, substitution].transform string } }

      it { expected_result.to return_a_kind_of String }
      it "is expected to include ANSI color codes" do
        expected_result.to include(Term::ANSIColor.blue)
      end
    end
  end

  describe Hilight::Fabric do
    it { is_expected.to have_attributes(collection: a_kind_of(Array).or(be_nil)) }
    it { is_expected.to respond_to(:transform).with(1).argument.and_keywords(:stop_on_first_match) }

    describe "#transform" do
      let(:pattern) { Hilight::Pattern[regexp, substitution] }
      let(:pattern2) { Hilight::Pattern[/(?<red>:symbol)/, '\k<red>'] }
      let(:subject) { proc { Hilight::Fabric[[pattern, pattern2]].transform string } }

      it "is expected to call transform on each pattern" do
        expected_result.to include(Term::ANSIColor.red)
      end

      context "when stop_on_first_match is set and the pattern matches" do
        let(:subject) { proc { Hilight::Fabric[[pattern, pattern2]].transform string, stop_on_first_match: true } }

        it "is expected to skip the rest of the matches" do
          expected_result.not_to include(Term::ANSIColor.red)
        end
      end
    end
  end
end
