require "hilight/version"
require 'term/ansicolor'

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

Hilight::Pattern = Struct.new :regexp, :substitution
Hilight::Pattern.define_method(:match?) { |string| regexp.match? string }
Hilight::Pattern.define_method(:transform) do |input|
  recursive_replace(input).string
end

Hilight::Pattern.define_method(:recursive_replace) do |input, output = StringIO.new|
  match = regexp.match input
  return input unless match

  output << match.pre_match
  color, sub_string = match.named_captures.find { |_key, value| !value.nil? }
  output << Term::ANSIColor.color(color, sub_string)
  recursive_replace(match.post_match, output) unless match.post_match.blank?
  output
end

Hilight::Fabric = Struct.new :collection
Hilight::Fabric.define_method(:transform) do |input, stop_on_first_match: false|
  output = StringIO.new
  collection.each do |pattern|
    pattern.recursive_replace input, output
    return output.string if stop_on_first_match && pattern.match?(input)
  end
  output.string
end
