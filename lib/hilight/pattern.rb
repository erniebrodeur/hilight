class Hilight::Pattern
  attr_accessor :pairs

  def define_methods
    pairs.each { |pair| Hilight.define_singleton_method(pair.verb) { |s| "\e[#{pair.code}m#{s}\e[0m" } }
  end

  def to_h
    pairs.map { |p| [p.verb, p.code] }.to_h
  end
end
