class Hilight::Quilt
  attr_accessor :fabric
  attr_accessor :pattern

  def to_h
    { fabric: fabric.to_h, pattern: pattern.to_h }
  end

  def self.create_from_hash(hash = {})
    new(
      Fabric[hash[:fabric][:pattern], hash[:fabric][:regexps].map { |r| Regexp.new r }],
      Pattern[hash[:pattern].map { |k, v| Pair[k.to_s, v] }]
    )
  end
end
