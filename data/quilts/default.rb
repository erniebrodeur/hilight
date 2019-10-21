{
  fabric:  {
    match_pattern: "--help",
    regexps:       [
      /(?<argument>\\B-{1,2}[\\w-]+)|(?<boundary>[\\[\\]\\(\\)\\{\\}\\<\\>])|(?<string>[\"'].*?[\"'])/
    ]
  },
  pattern: {
    argument: "33",
    boundary: "34",
    string:   "32"
  }
}
