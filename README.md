# Hilight

Hilight will highlight CLI based applications based on regular expressions.

Ever wanted colors in an app that doesn't support them?

    hilight git -h

- Supports regexp for the command, as well as strings.
- No outside dependencies.
- Can add syntaxes via serializable JSON or ruby.

## Installation

    gem install hilight

## Usage

Basic highlighting can be done with:

    hilight command

It can be used in a piped expression.

    git -h | hilight

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/erniebrodeur/hilight. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Pull Requests

Pull requests that do not pass current rspecs or do not contain coverage of the code in the pull request are, most likely, going to be rejected.

If you want to add a theme/change an existing one, please submit all updates
in the JSON form of the quilt.

## Code of Conduct

Everyone interacting in the Hilight project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/erniebrodeur/hilight/blob/master/CODE_OF_CONDUCT.md).
