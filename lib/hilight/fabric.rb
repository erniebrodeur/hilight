class Hilight::Fabric
  attr_accessor :regexps
  attr_accessor :pattern

  def match?(string)
    raise ArgumentError, "#{string} is not a kind of String" unless string.is_a? String

    case pattern
    when Symbol then (pattern.to_s == string)
    when String then (pattern == string)
    when Regexp then (pattern.match? string.to_s)
    else false
    end
  end

  def transform(string)
    Hilight.transform string, regexps
  end

  def to_h
    { pattern: pattern, regexps: regexps.map(&:to_s) }
  end
end
