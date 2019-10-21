module Hilight
  class Quilt
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
        Fabric.new(Regexp.new(hash[:fabric][:match_pattern]), hash[:fabric][:regexps]
          .map { |r| Regexp.new r }),
        Pattern.new(hash[:pattern].map { |k, v| Pair[k.to_s, v] })
      )
    end

    def self.load_from_ruby_file(filename)
      raise "#{filename} does not exist" unless File.exist? filename

      create_from_hash eval File.read(filename)
    end
  end
end
