require 'spec_helper'

RSpec.describe Hilight::Quilts do
  # let(:fabric) { Hilight::Fabric.new 'test', [/one/] }
  # let(:pattern) { Hilight::Pattern.new([Hilight::Pair['verb', '31'], Hilight::Pair['noun', '32']]) }

  it { is_expected.to have_attributes(collection: a_kind_of(Array).or(be_nil)) }

  it { is_expected.to respond_to(:find_quilt).with(1).arguments }
  it { is_expected.to respond_to(:load_quilts_from_gem).with(0).arguments }

  describe "#load_quilts_from_gem" do
    it "is expected to load all quilts from the gem"
    it "is expected to not duplicate entries"
    it "is expected to load from data/quilts"
    it "is expected to load from rb quilts"
  end
end
