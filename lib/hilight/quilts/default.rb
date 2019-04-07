module Hilight
  module Quilts
    Default = Quilt.create_from_hash(
      "fabric"  => {
        "match_pattern" => "default",
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
