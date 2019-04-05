require 'spec_helper'

RSpec.describe Hilight do
  it { is_expected.to respond_to(:transform).with(2).arguments }

  it "is expected to have a version number" do
    expect(Hilight::VERSION).not_to be nil
  end

  describe "Basic Color Methods" do
    colors = %i[black red green yellow blue magenta cyan white]

    colors.each do |color|
      it { is_expected.to respond_to(color).with(1).arguments }
      it { expect(described_class.send(color, 'test')).to return_a_kind_of(String) }
    end
  end

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

  describe Hilight::Pair do
    let(:subject) { Hilight::Pair['test', '31'] }

    it { is_expected.to have_attributes(verb: a_kind_of(String)) }
    it { is_expected.to have_attributes(code: a_kind_of(String)) }
  end
end
