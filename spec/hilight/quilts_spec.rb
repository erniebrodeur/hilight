require 'spec_helper'

RSpec.describe Hilight::Quilt do
  let(:fabric) { Hilight::Fabric.new 'test', [/one/] }
  let(:pattern) { Hilight::Pattern.new([Hilight::Pair['verb', '31'], Hilight::Pair['noun', '32']]) }

  let(:subject) { described_class.new(fabric, pattern) }

  it { is_expected.to have_attributes(collection: a_kind_of(Array).or(be_nil)) }

  # it { expect(described_class).to respond_to(:create_from_hash).with(0).arguments }

  # it { is_expected.to respond_to(:match?).with(1).arguments }
  # it { is_expected.to respond_to(:to_h).with(0).arguments }
  # it { is_expected.to respond_to(:transform).with(1).arguments }
end
