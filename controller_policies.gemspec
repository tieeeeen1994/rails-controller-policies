# frozen_string_literal: true

require_relative 'lib/controller_policies/version'

Gem::Specification.new do |spec|
  spec.name = 'controller_policies'
  spec.version = ControllerPolicies::VERSION
  spec.authors = ['Tien']
  spec.email = ['tieeeeen1994@gmail.com']

  spec.summary = 'Allows the developer to define policies for controllers.'
  spec.homepage = 'https://github.com/tieeeeen1994/rails-controller-policies'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[spec/ .git .github Gemfile .vscode]) ||
        f.end_with?(*%w[.gem .yml .rspec .gitignore])
    end
  end
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'rails', '~> 7'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
