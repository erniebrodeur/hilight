require "hilight/version"
require 'term/ansicolor'

Hilight::Pattern = Struct.new :regexp, :substitution
Hilight::Fabric = Struct.new :collection

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

Hilight::Pattern.define_method(:match?) { |string| regexp.match? string }
Hilight::Pattern.define_method(:transform) do |input|
  match = regexp.match input
  output = []

  while match
    output.push match.pre_match unless match.pre_match.empty?

    captured_string = match.to_a[0]
    color_lookup_list = match.named_captures.invert

    match.to_a[1..-1].each do |s|
      color = color_lookup_list[s]
      captured_string.gsub!(s, Term::ANSIColor.color(color, s)) if s
    end

    # match.named_captures.each do |color, string|
    # end
    output.push captured_string if captured_string

    post_match = match.post_match
    match = regexp.match(match.post_match)

    output.push post_match unless match
  end

  output
end

Hilight::Fabric.define_method(:transform) do |input|
  Hilight::Pattern[Regexp.union collection.map(&:regexp)].transform input
end
