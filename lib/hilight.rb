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

Hilight::Fabric = Struct.new :collection
Hilight::Fabric.define_method(:transform) do |input|
  Hilight::Pattern[Regexp.union collection.map(&:regexp)].transform input
end
