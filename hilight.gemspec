lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hilight/version"

Gem::Specification.new do |spec|
  spec.name          = "hilight"
  spec.version       = Hilight::VERSION
  spec.authors       = ["Ernie Brodeur"]
  spec.email         = ["ebrodeur@ujami.net"]

  spec.summary       = "hilight"
  spec.description   = "hilight all the things."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'term-ansicolor'

  spec.add_development_dependency "bundler", "~> 2.0"
end
