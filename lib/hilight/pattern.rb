module Hilight
  # Hilight::Pattern - responsible for the colorization of our matches.
  class Pattern
    attr_accessor :pairs

    def initialize(pairs)
      @pairs = pairs
    end

    # Define color methods for the pattern.
    # @return [Nil]
    def define_methods
      pairs.each { |pair| Hilight.define_singleton_method(pair.verb) { |s| "\e[#{pair.code}m#{s}\e[39;49m" } }
    end

    def to_h
      pairs.map { |p| [p.verb, p.code] }.to_h
    end
  end
end
