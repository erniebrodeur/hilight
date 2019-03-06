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

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

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

      before { allow(File).to receive(:exist?).with(filename).and_return true }

      specify do
        described_class.load(filename)
        expect(Kernel).to have_received(:load).with filename
      end

    context "when the filename does not exist" do
      let(:expected_filename) { "#{Dir.home}/.config/hilight/patterns/#{filename}" }

      before { allow(File).to receive(:exist?).with(filename).and_return false }

      specify do
        allow(Kernel).to receive(:load).with expected_filename
        described_class.load(filename)
        expect(Kernel).to have_received(:load).with expected_filename
      end
    end

    context "when the file could not be loaded from the config directory" do
      it "is expected to look in the gem for any default pattern"
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
end
