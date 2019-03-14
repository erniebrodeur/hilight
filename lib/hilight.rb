require "hilight/version"
require 'term/ansicolor'

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

Hilight::Pattern = Struct.new :regexp, :substitution
Hilight::Pattern.define_method(:match?) { |string| regexp.match? string }
Hilight::Pattern.define_method(:transform) do |input|
  # map our colors in to the matches
  regexp.names.map { |n| substitution.gsub!("\\k<#{n}>") { |s| Term::ANSIColor.color(n, s) } }
  # map our input into the output, return the original if it doesn't map (replace) anything.
  input.gsub!(regexp, substitution) || input
end

Hilight::Fabric = Struct.new :collection
Hilight::Fabric.define_method(:transform) do |input, stop_on_first_match: false|
  output = input.dup

  collection.each do |pattern|
    output = pattern.transform output
    return output if stop_on_first_match && pattern.match?(input)
  end
  output
end
