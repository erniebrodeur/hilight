module Hilight
  module Quilts
    Rspec = Quilt.create_from_hash(
      "fabric"  => {
        "match_pattern" => "rspec",
        "regexps"       => [
          "(?-mix:(?<test_count>\\d+) examples, (?<test_failures>\\d+) failures?, (?<test_pending>\\d+) pending)",
          "(?-mix:\"(?<string>.*?)\")",
          "(?-mix:'(?<string>.*?)')",
          "(?-mix:# (?<line>.*):(?<line_number>\\d+))"
        ]
      },
      "pattern" => {
        "string"        => "38;2;229;92;7",
        "test_count"    => "32",
        "test_failures" => "31",
        "test_pending"  => "33",
        "line"          => "36",
        "line_number"   => "38;2;100;100;100"
      }
    )
  end
end
