require 'spec_helper'

RSpec.describe Hilight do
  let(:expected_result) { expect(subject.call) } # rubocop: disable all
  let(:regexp) { /(?<green>'.*')|(?<blue>".*")/ }
  let(:substitution) { '\k<green>\k<blue>' }
  let(:result) { subject.call }
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

  describe Hilight::Pattern do
    it { is_expected.to have_attributes(regexp: a_kind_of(Regexp).or(be_nil)) }
    it { is_expected.to have_attributes(substitution: a_kind_of(String).or(be_nil)) }
    it { is_expected.to respond_to(:transform).with(1).arguments}
    xit { is_expected.to respond_to(:transform_stream).with(1).arguments}
    xit { is_expected.to respond_to(:match?).with(1).arguments}

    describe "#transform" do
      let(:subject) { proc { Hilight::Pattern[regexp, substitution].transform(string) } }

      it { expected_result.to return_a_kind_of String}
      it "is expected to include ANSI color codes" do
        expected_result.to include(Term::ANSIColor.blue)
      end
    end
  end

  ### String IO Arch
  # pattern => Struct[:regexp, :substitution]
  #             .transform(input_string) (String)
  #             .transform_stream(IO) (IO)
  #             .match?(input_string) (Boolean)

  # patterns => pattern[]
  #             .transform(input_string, stop_on_first: false) (String)
  #             .transform_stream(IO) (IO)

end
