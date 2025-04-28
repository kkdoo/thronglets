# frozen_string_literal: true

require_relative "lib/thronglets/version"

Gem::Specification.new do |spec|
  spec.name = "thronglets"
  spec.version = Thronglets::VERSION
  spec.authors = [ "Artem Mashchenko" ]
  spec.email = [ "artem.maschenko@gmail.com" ]

  spec.summary = "Microservices with Ruby and Temporal"
  spec.homepage = "https://github.com/kkdoo/thronglets"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/kkdoo/thronglets/issues",
    "changelog_uri" => "https://github.com/kkdoo/thronglets/releases",
    "source_code_uri" => "https://github.com/kkdoo/thronglets",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = [ "lib" ]

  # Runtime dependencies
  spec.add_dependency "thor", "~> 1.2"
end
