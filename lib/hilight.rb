require 'hilight/fabric'
require 'hilight/pattern'
require 'hilight/quilt'
require "hilight/version"

module Hilight
  module_function

  Pair = Struct.new :verb, :code

  define_method(:black)   { |s| "\e[30m" + s.to_s + "\e[0m" }
  define_method(:red)     { |s| "\e[31m" + s.to_s + "\e[0m" }
  define_method(:green)   { |s| "\e[32m" + s.to_s + "\e[0m" }
  define_method(:yellow)  { |s| "\e[33m" + s.to_s + "\e[0m" }
  define_method(:blue)    { |s| "\e[34m" + s.to_s + "\e[0m" }
  define_method(:magenta) { |s| "\e[35m" + s.to_s + "\e[0m" }
  define_method(:cyan)    { |s| "\e[36m" + s.to_s + "\e[0m" }
  define_method(:white)   { |s| "\e[37m" + s.to_s + "\e[0m" }

  def load(filename)
    return Kernel.load filename if File.exist? filename

    Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
  end

  def transform(input, regexps = [])
    raise ArgumentError, "#{input} is not a kind of String" unless input.is_a? String
    raise ArgumentError, "#{input} is not a kind of Array or Regexp" unless regexps.is_a?(Array) || regexps.is_a?(Regexp)

    regexp = Regexp.union regexps

    match = regexp.match input
    return input unless match

    output = []
    while match
      output.push match.pre_match unless match.pre_match.empty?

      captured_string = match.to_a[0]
      color_lookup_list = match.named_captures.invert

      match.to_a[1..-1].each do |s|
        next unless s

        color = color_lookup_list[s]
        captured_string.gsub!(s, Hilight.send(color, s))
      end

      output.push captured_string if captured_string

      post_match = match.post_match
      match = regexp.match(match.post_match)

      output.push post_match unless match
    end

    output.join("")
  end
end
