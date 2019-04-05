require 'spec_helper'

RSpec.describe Hilight::Fabric do
  let(:fabric) { described_class.new 'test', [/one/] }
  let(:subject) { fabric }

  it { is_expected.to have_attributes(match_pattern: a_kind_of(String).or(be_nil)) }
  it { is_expected.to have_attributes(regexps: a_kind_of(Array).or(a_kind_of(Regexp)).or(be_nil)) }
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
      it { expect { fabric.match? 1 }.to raise_error ArgumentError, /is not a kind of String/ }
    end

    context "with a regexp pattern" do
      let(:pattern) { /test/ }
      let(:subject) { described_class.new(pattern, [/one/]).match? 'test' }

      it { is_expected.to be true }

      it "is expected to test with Regexp.match" do
        allow(pattern).to receive(:match?).and_call_original
        subject
        expect(pattern).to have_received(:match?)
      end
    end

    context "with a symbol pattern" do
      let(:subject) { described_class.new(:test, [/one/]).match? 'test' }

      it "is expected to treat it like a string" do
        expect(subject).to be true
      end
    end

    context "with a string pattern" do
      let(:pattern) { 'test' }
      let(:subject) { described_class.new(pattern, [/one/]).match? 'test' }

      it { is_expected.to be true }

      it "is expected to test equality" do
        allow(pattern).to receive(:==).and_call_original
        subject
        expect(pattern).to have_received(:==)
      end
    end
  end
end
