require 'spec_helper'

RSpec.describe Hilight do
  it { is_expected.to respond_to(:load).with(1).arguments }
  it { is_expected.to respond_to(:transform).with(2).arguments }

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

  # puts Pattern[/(?<red>two) three (?<yellow>four)/].transform('one two three four five').join("")
  # # puts Pattern[/\"(?<green>.*?)\"|\'(?<green>.*?)\'/].transform('a "little" rabbit').join("")

  describe "#transform" do
    let(:input) { "one two three four five six" }
    let(:expected_result) { "one \e[31mtwo\e[0m three \e[34mfour\e[0m five six" }
    let(:red_pattern) { /(?<red>two)/ }
    let(:blue_pattern) { /(?<blue>four)/ }
    let(:patterns) { [red_pattern, blue_pattern] }
    let(:subject) { described_class.transform(input, patterns) }

    before do
      ::String.define_method(:transformed?) { include? "\e[" }
    end

    it { is_expected.to be_transformed }

    it "is expected to union the regexp array" do
      expect(subject).to eq expected_result
    end

    context "when the first argument is not a string" do
      let(:input) { [] }

      it { expect { subject }.to raise_error ArgumentError, /is not a kind of String/ }
    end

    context "when the second argument is not an array" do
      let(:patterns) { 1 }

      it { expect { subject }.to raise_error ArgumentError, /is not a kind of Array or Regexp/ }
    end

    context "when the second argument is a single regexp" do
      let(:patterns) { red_pattern }
      let(:expected_result) { "one \e[31mtwo\e[0m three four five six" }

      it "is expected to treat it as an array" do
        expect(subject).to eq expected_result
      end
    end

    context "when no capture group is matched" do
      it "is expected to return the original string" do
        expect(described_class.transform('seven', patterns)).to eq 'seven'
      end
    end

    context "when a capture group is matched" do
      it "is expected to wrap the capture group with ANSI color codes" do
        expect(subject).to include("\e[31mtwo\e[0m")
      end
    end

    context "when a capture has more than one part" do
      it "is expected to not lose characters in between the capture groups" do
        expect(subject).to include(" three ")
      end
    end

    context "when a capture has a pre_match or post_match group" do
      it "is expected to include the pre_match group" do
        expect(subject).to start_with "one "
      end

      it "is expected to transform the post_match group" do
        expect(subject).to include("\e[34mfour\e[0m")
      end
    end
  end

  describe Hilight::Fabric do
  let(:fabric) { described_class['test', [/one/]] }

  it { is_expected.to have_attributes(pattern: a_kind_of(String).or(be_nil)) }
  it { is_expected.to have_attributes(pattern: a_kind_of(Array).or(a_kind_of(Regexp)).or(be_nil)) }
  it { is_expected.to respond_to(:match?).with(1).arguments }
  it { is_expected.to respond_to(:transform).with(1).arguments }

  describe "#transform" do
    it "is expected to call Hilight.transform with the argument and regexps parameter" do
      allow(Hilight).to receive(:transform).and_call_original
      fabric.transform('one two three')
      expect(Hilight).to have_received(:transform).with('one two three', [/one/])
    end
  end

  describe "#match?" do
    let(:subject) { fabric.match? 'not_a_test' }

    it { is_expected.to be false }

    context "when the argument is not a String" do
      it { expect { fabric.match? 1 }.to raise_error ArgumentError, /is not a kind of String/}
    end

    context "with a regexp pattern" do
      let(:pattern) { /test/ }
      let(:fabric) { described_class[pattern, [/one/]] }
      let(:subject) { fabric.match? 'test' }

      it { is_expected.to be true }

      it "is expected to test with Regexp.match" do
        allow(pattern).to receive(:match?).and_call_original
        subject
        expect(pattern).to have_received(:match?)
      end
    end

    context "with a symbol pattern" do
      let(:fabric) { described_class[:test, [/one/]] }
      let(:subject) { fabric.match? 'test' }

      it "is expected to treat it like a string" do
        expect(subject).to be true
      end
    end

    context "with a string pattern" do
      let(:pattern) { 'test' }
      let(:fabric) { described_class[pattern, [/one/]] }
      let(:subject) { fabric.match? 'test' }

      it { is_expected.to be true }

      it "is expected to test equality" do
        allow(pattern).to receive(:==).and_call_original
        subject
        expect(pattern).to have_received(:==)
      end
    end
  end
end
end
