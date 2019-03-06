require "hilight/version"
require 'term/ansicolor'

Hilight::Pattern = Struct.new :regexp, :replacement
Hilight::Pattern.define_method(:output) do |input|
  # map our colors in to the matches
  regexp.names.map { |n| replacement.gsub!("\\k<#{n}>") { |s| Term::ANSIColor.color(n, s) } }
  # map our input into the output, return the original if it doesn't map (replace) anything.
  input.gsub!(regexp, replacement) || input
end

Hilight::Patterns = Struct.new :patterns
Hilight::Patterns.define_method(:output) do |input|
  patterns.each { |pattern| input = pattern.output(input) }
  input
end

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end
