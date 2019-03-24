require "hilight/version"
require 'term/ansicolor'

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

Hilight.define_singleton_method(:transform) do |input, regexps = []|
  raise ArgumentError, "#{input} is not a kind of String" unless input.is_a? String
  raise ArgumentError, "#{input} is not a kind of Array or Regexp" unless regexps.is_a?(Array) || regexps.is_a?(Regexp)

  regexp = Regexp.union regexps

  match = regexp.match input
  output = []

  while match
    output.push match.pre_match unless match.pre_match.empty?

    captured_string = match.to_a[0]
    color_lookup_list = match.named_captures.invert

    match.to_a[1..-1].each do |s|
      next unless s

      color = color_lookup_list[s]
      captured_string.gsub!(s, Term::ANSIColor.color(color, s))
    end

    output.push captured_string if captured_string

    post_match = match.post_match
    match = regexp.match(match.post_match)

    output.push post_match unless match
  end

  output.join("")
end
