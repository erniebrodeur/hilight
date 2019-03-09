require "hilight/version"
require 'term/ansicolor'

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

Hilight::Filter = Struct.new(:cmd, :patterns)
Hilight::Filter.define_method(:match?) do |string|
  case cmd
  when (String || Symbol) then (cmd.to_s == string.to_s)
  when Regexp then (cmd.match? string.to_s)
  else false
  end
end

Hilight::Filters = Struct.new(:collection)
Hilight::Filters.define_method(:find) do |string|
  filter = collection.find { |f| f.match? string } || collection.find { |e| e.cmd == 'default' }
  filter
end

Hilight::Filters.define_method(:run) do
  arg_string = ARGV.join(' ')

  f = find arg_string

  output, process = Open3.capture2e(arg_string)

  puts f.patterns.output(output)

  exit process.exitstatus
end

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
