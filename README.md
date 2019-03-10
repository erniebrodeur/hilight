# Hilight

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/hilight`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hilight'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hilight

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/erniebrodeur/hilight. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Hilight project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/erniebrodeur/hilight/blob/master/CODE_OF_CONDUCT.md).

["patterns"].map { |m| Match.new m["regexp"],m["sub_string"]  }

``` yaml
:cmd: rspec
:patterns:
- :regexp: (?<green>\\d+) examples, (?<red>\\d+) failures, (?<yellow>\\d+) pending
  :sub_string: \\k<green> examples, \\k<red> failures, \\k<yellow> pending
- :regexp: (?<blue>\\d+\\.\\d+)
  :sub_string: \\k<blue>
- :regexp: (?<green>.*?)\"|\'(?<green>.*?)\'
  :sub_string: \\k<green>
- :regexp: "# (?<red>.*):(?<yellow>\d+)"
  :sub_string: \\k<red>:\\k<yellow>
```

``` ruby
{
  "cmd" =>     "rspec",
  "patterns" =>[
    {
      "regexp" =>    %r{(?<green>\d+) examples, (?<red>\d+) failures, (?<yellow>\d+) pending},
      "sub_string" =>'\k<green> examples, \k<red> failures, \k<yellow> pending'
    },
    {
      "regexp" =>    %r{(?<blue>\d+\.\d+)},
      "sub_string" =>'\k<blue>'
    },
    {
      "regexp" =>    %r{"(?<green>.*?)"|'(?<green>.*?)'},
      "sub_string" =>'\k<green>'
    },
    {
      "regexp" =>    %r{# (?<red>.*):(?<yellow>\d+)},
      "sub_string" =>'\k<red>:\k<yellow>'
    }
  ]
}
```


``` json
{
  ":cmd":"rspec",
  ":patterns":[
    {
      ":regexp":"(?<green>\\d+) examples, (?<red>\\d+) failures, (?<yellow>\\d+) pending",
      ":sub_string":"\\k<green> examples, \\k<red> failures, \\k<yellow> pending"
    },
    {
      ":regexp":"(?<blue>\\d+\\.\\d+)",
      ":sub_string":"\\k<blue>"
    },
    {
      ":regexp":"(?<green>.*?)\\\"|'(?<green>.*?)'",
      ":sub_string":"\\k<green>"
    },
    {
      ":regexp":"\\# (?<red>.*):(?<yellow>\\d+)",
      ":sub_string":"\\k<red>:\\k<yellow>"
    }
  ]
}```


(pick our input from cmd matching)
 ->(input)->(select our pattern[])->(stringify input)
 ->(add colors)->(stringify output)


### Pattern selection / cmdline matching
filter => Struct[:filter_regexp, :selected_patterns]
            .find(input_string) (patterns)


### String IO Arch
pattern => Struct[:regexp, :replacement_pattern]
             .transform(input_string) (String)
             .transform_stream(IO) (IO)
             .match?(input_string) (Boolean)

patterns => pattern[]
             .transform(input_string, stop_on_first: false) (String)
             .transform_stream(IO) (IO)
