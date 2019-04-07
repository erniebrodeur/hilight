module Hilight
  module Quilts
    Ruby = Quilt.create_from_hash(
      'fabric'  => {
        'match_pattern' => "ruby",
        'regexps'       => [
          /\"(?<string>.*?)\"/,
          /'(?<string>.*?)'/
        ]
      },
      'pattern' => { "string" => "31", "comment" => "32" }
    )
  end
end
