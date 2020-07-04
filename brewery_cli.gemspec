require_relative 'lib/brewery_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "brewery_cli"
  spec.version       = BreweryCli::VERSION
  spec.authors       = ["patrick-rush"]
  spec.email         = ["patrick.a.rush@gmail.com"]

  spec.summary       = %q{CLI for finding local breweries using Open Brewery DB}
  spec.description   = %q{CLI for finding local breweries using Open Brewery DB}
  spec.homepage      = "https://github.com/patrick-rush/brewery_cli"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/patrick-rush/brewery_cli"
  spec.metadata["changelog_uri"] = "https://github.com/patrick-rush/brewery_cli"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir        = "exe"
  spec.executables   = ["brewery_cli"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry"
  spec.add_dependency "colorize"
end
