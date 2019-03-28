module Hilight
  Fabric = Struct.new :pattern, :regexps
  Fabric.define_method(:match?) do |string|
    raise ArgumentError, "#{string} is not a kind of String" unless string.is_a? String

    case pattern
    when Symbol then (pattern.to_s == string)
    when String then (pattern == string)
    when Regexp then (pattern.match? string.to_s)
    else false
    end
  end

  Fabric.define_method(:transform) do |string|
    Hilight.transform string, regexps
  end
end
