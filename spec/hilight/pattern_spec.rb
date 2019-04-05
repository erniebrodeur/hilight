require 'spec_helper'

RSpec.describe Hilight::Pattern do
  let(:subject) { described_class.new([Hilight::Pair['verb', '31'], Hilight::Pair['noun', '32']]) }

  it { expect(described_class).to respond_to(:new).with(1).arguments }
  it { is_expected.to have_attributes(pairs: a_kind_of(Array).or(be_nil)) }
  it { is_expected.to respond_to(:to_h).with(0).arguments }
  it { is_expected.to respond_to(:define_methods).with(0).arguments }

  describe "#define_methods" do
    before { subject.define_methods }

    it "is expected to define methods in the Hilight module" do
      expect(Hilight).to respond_to(:verb).with(1).arguments
    end

    it "is expected to define a method for each pair" do
      expect(Hilight.methods(false)).to include(:verb, :noun)
    end

    it "is expected to define a method that requires a string argument" do
      expect { Hilight.verb('this') }.not_to raise_error
    end

    context "when the defined method is called" do
      it "is expected to return the string wrapped in ANSI with the code from the pair" do
        expect(Hilight.verb('this')).to eq "\e[31mthis\e[39;49m"
      end
    end
  end

  describe "#to_h" do
    it "is expected to output self as a hash" do
      expect(subject.to_h).to eq("noun" => "32", "verb" => "31")
    end
  end
end
