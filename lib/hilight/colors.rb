require 'hilight'
include Hilight

Pair = Struct.new :verb, :code

Pattern = Struct.new :pairs
Pattern.define_method(:define_methods) do
  pairs.each { |pair| Hilight.define_singleton_method(pair.verb) { |s| "\e[#{pair.code}m#{s}\e[0m" } }
end
Pattern.define_method(:to_h) { pairs.map { |p| [p.verb, p.code] }.to_h }

Fabric.define_method(:to_h) { { pattern: pattern, regexps: regexps.map(&:to_s) } }

Quilt = Struct.new :fabric, :pattern
Quilt.define_method(:to_h) { { fabric: fabric.to_h, pattern: pattern.to_h } }
{
  "fabric":  {
    "pattern": "rspec",
    "regexps": [
      "(?-mix:(?<test_count>\\d+) examples, (?<test_failures>\\d+) failures?, (?<test_pending>\\d+) pending)",
      "(?-mix:\"(?<comment>.*?)\")",
      "(?-mix:'(?<comment>.*?)')",
      "(?-mix:# (?<line>.*):(?<line_number>\\d+))"
    ]
  },
  "pattern": {
    "comment":       32,
    "test_count":    32,
    "test_failures": 31,
    "test_pending":  33,
    "line":          36,
    "line_number":   36
  }
}
Quilt.define_singleton_method(:create_from_hash) do |hash = {}|
  Quilt[
    Fabric[hash[:fabric][:pattern], hash[:fabric][:regexps].map { |r| Regexp.new r }],
    Pattern[hash[:pattern].map { |k,v| Pair[k.to_s,v] }]
  ]
end

rspec = Quilt[
  Fabric[
    'rspec', [
      /(?<test_count>\d+) examples, (?<test_failures>\d+) failures?, (?<test_pending>\d+) pending/,
      /"(?<comment>.*?)"/,
      /'(?<comment>.*?)'/,
      /# (?<line>.*):(?<line_number>\d+)/
    ]
  ],
  Pattern[
    [
      Pair['comment', 32],
      Pair['test_count', 32],
      Pair['test_failures', 31],
      Pair['test_pending', 33],
      Pair['line', 36],
      Pair['line_number', 36]
    ]
  ]
]

require 'pry'
binding.pry
