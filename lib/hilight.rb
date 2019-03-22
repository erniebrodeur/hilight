require "hilight/version"
require 'term/ansicolor'

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

Hilight::Pattern = Struct.new :regexp, :substitution
Hilight::Pattern.define_method(:match?) { |string| regexp.match? string }
Hilight::Pattern.define_method(:transform) do |input|
  match = regexp.match input
  output = []

  while match
    output.push match.pre_match unless match.pre_match.empty?

    match.named_captures.each do |color, string|
      output.push Term::ANSIColor.color color, string if string
    end

    post_match = match.post_match
    match = regexp.match(match.post_match)

    output.push post_match unless match
  end

  output
end

Hilight::Pattern.define_method(:offsets) do |input|
  offsets = {}
  offsets['clear'] = []

  m = regexp.match input
  while m
    m.named_captures.each do |color, string|
      next unless string

      offsets[color] ||= []
      offsets[color].push m.offset(color)[0]
      offsets['clear'].push m.offset(color)[1]
    end

    m = regexp.match(m.post_match)
  end
  offsets
end

# Hilight::Pattern.define_method(:recursive_replace) do |input, output = StringIO.new|
#   match = regexp.match input
#   return input unless match

#   output << match.pre_match
#   color, sub_string = match.named_captures.find { |_key, value| !value.nil? }
#   output << Term::ANSIColor.color(color, sub_string)
#   recursive_replace(match.post_match, output) unless match.post_match.blank?
#   output
# end

Hilight::Fabric = Struct.new :collection
Hilight::Fabric.define_method(:transform) do |input, stop_on_first_match: false|
  Hilight::Pattern[Regexp.union collection.map(&:regexp)].transform input
end
