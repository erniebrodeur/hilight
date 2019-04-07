module Hilight
  module Quilts
    Help = Quilt.create_from_hash(
      "fabric"  => {
        "match_pattern" => "(?-mix:-h|--help|help)",
        "regexps"       => [
          "(?-mix:(?<argument>\\B-{1,2}[\\w-]+)|(?<boundary>[\\[\\]\\(\\)\\{\\}\\<\\>])|(?<string>[\"'].*?[\"']))"
        ]
      },
      "pattern" => {
        "argument" => "33",
        "boundary" => "34",
        "string"   => "32"
      }
    )
  end
end
