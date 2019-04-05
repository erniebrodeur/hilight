require 'spec_helper'

RSpec.describe Hilight::Quilt do
  let(:fabric) { Hilight::Fabric.new 'test', [/one/] }
  let(:pattern) { Hilight::Pattern.new([Hilight::Pair['verb', '31'], Hilight::Pair['noun', '32']]) }

  let(:subject) { described_class.new(fabric, pattern) }

  it { is_expected.to have_attributes(fabric: a_kind_of(Hilight::Fabric).or(be_nil)) }
  it { is_expected.to have_attributes(pattern: a_kind_of(Hilight::Pattern).or(be_nil)) }

  it { expect(described_class).to respond_to(:create_from_hash).with(0).arguments }

  it { is_expected.to respond_to(:match?).with(1).arguments }
  it { is_expected.to respond_to(:to_h).with(0).arguments }
  it { is_expected.to respond_to(:transform).with(1).arguments }

  describe "#match?" do
    it "is expected to call fabric.match? with the argument" do
      allow(fabric).to receive(:match?).and_call_original
      subject.match? 'test'
      expect(fabric).to have_received(:match?).with('test')
    end
  end

  describe "#to_h" do
    it "is expected to output self as a hash" do
      expect(subject.to_h).to eq(fabric: fabric.to_h, pattern: pattern.to_h)
    end
  end

  describe "#transform" do
    it "is expected to call pattern.define_methods" do
      allow(pattern).to receive(:define_methods).and_call_original
      subject.transform 'test'
      expect(pattern).to have_received(:define_methods)
    end

    it "is expected to call fabric.transform" do
      allow(fabric).to receive(:transform).and_call_original
      subject.transform 'test'
      expect(fabric).to have_received(:transform).with('test')
    end

    it "is expected to return the result of fabric.transform" do
      expect(subject.transform('test')).to eq 'test'
    end
  end
end
