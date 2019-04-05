class Hilight::Quilt
  attr_accessor :fabric
  attr_accessor :pattern

  def initialize(fabric, pattern)
    @fabric = fabric
    @pattern = pattern
  end

  def match?(string)
    fabric.match? string
  end

  def transform(string)
    pattern.define_methods
    fabric.transform string
  end

  def to_h
    { fabric: fabric.to_h, pattern: pattern.to_h }
  end

  def self.create_from_hash(hash = {})
    new(
      Fabric.new(Regexp.new(hash['fabric']['pattern']), hash['fabric']['regexps'].map { |r| Regexp.new r }),
      Pattern.new(hash['pattern'].map { |k, v| Pair[k.to_s, v] })
    )
  end

  def self.load_from_gem(name)
    create_from_hash(
      JSON.parse(
        File.read("#{gem_dir}/data/quilts/#{name}_quilt.json")
      )
    )
  end
end
