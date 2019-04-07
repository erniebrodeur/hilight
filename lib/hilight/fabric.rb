module Hilight
  class Fabric
    attr_accessor :regexps
    attr_accessor :match_pattern

    def initialize(match_pattern, regexps)
      @regexps = regexps
      @match_pattern = match_pattern
    end

    def match?(string)
      raise ArgumentError, "#{string} is not a kind of String" unless string.is_a? String

      case match_pattern
      when Symbol then (match_pattern.to_s == string)
      when String then (match_pattern == string)
      when Regexp then (match_pattern.match? string.to_s)
      else false
      end
    end

    def transform(string)
      Hilight.transform string, regexps
    end

    def to_h
      { match_pattern: match_pattern, regexps: regexps.map(&:to_s) }
    end
  end
end
