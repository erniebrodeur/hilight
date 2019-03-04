require 'spec_helper'

Hilight::Pattern = Struct.new :regexp, :replacement
Hilight::Pattern.define_method(:output) do |input|
  # map our colors in to the matches
  regexp.names.map { |n| replacement.gsub!("\\k<#{n}>") { |s| Term::ANSIColor.color(n, s) } }
  # map our input into the output, return the original if it doesn't map (replace) anything.
  input.gsub!(regexp, replacement) || input
end

Hilight::Patterns = Struct.new :patterns
Hilight::Patterns.define_method(:output) do |input|
  patterns.each { |pattern| input = pattern.output(input) }
  input
end

RSpec.describe Hilight do
  let(:regexp) { /(?<green>'.*')|(?<blue>".*")/ }
  let(:replacement) { '\k<green>\k<blue>' }
  let(:string) { "here is 'an inline comment' and \"another\"" }

  it "has a version number" do
    expect(Hilight::VERSION).not_to be nil
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
        let(:string) { 'not a matching string'}

        it "is expected to return the original string" do
          expect(subject).to eq string
        end
      end
    end
  end
end
