require "hilight/version"
require 'term/ansicolor'

Hilight.define_singleton_method(:load) do |filename|
  return Kernel.load filename if File.exist? filename

  Kernel.load "#{Dir.home}/.config/hilight/patterns/#{filename}"
end

# Hilight::Filter = Struct.new(:cmd, :patterns)
# Hilight::Filter.define_method(:match?) do |string|
#   case cmd
#   when (String || Symbol) then (cmd.to_s == string.to_s)
#   when Regexp then (cmd.match? string.to_s)
#   else false
#   end
# end

# Hilight::Filters = Struct.new(:collection)
# Hilight::Filters.define_method(:find) do |match|
#   filter = collection.find { |f| f.match? match } || collection.find { |e| e.cmd == 'default' }
#   filter
# end

# Hilight::Filters.define_method(:exec) do |string|
#   f = find string

#   output, process = Open3.capture2e(string)

#   puts f.patterns.output(output)

#   exit process.exitstatus
# end

Hilight::Pattern = Struct.new :regexp, :substitution
Hilight::Pattern.define_method(:transform) do |input|
  # map our colors in to the matches
  regexp.names.map { |n| substitution.gsub!("\\k<#{n}>") { |s| Term::ANSIColor.color(n, s) } }
  # map our input into the output, return the original if it doesn't map (replace) anything.
  input.gsub!(regexp, substitution) || input
end

# Hilight::Patterns = Struct.new :patterns
# Hilight::Patterns.define_method(:output) do |input|
#   patterns.each { |pattern| input = pattern.output(input) }
#   input
# end
