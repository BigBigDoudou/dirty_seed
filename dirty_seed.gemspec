# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'dirty_seed/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.6'
  spec.name        = 'dirty_seed'
  spec.version     = DirtySeed::VERSION
  spec.authors     = ['Edouard Piron']
  spec.email       = ['ed.piron@gmail.com']
  spec.homepage    = 'https://github.com/BigBigDoudou/dirty_seed'
  spec.summary     = 'Summary of DirtySeed.'
  spec.description = 'Description of DirtySeed.'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.test_files = Dir['spec/**/*']

  spec.add_dependency 'faker', '~> 2.14.0'
  spec.add_dependency 'rails', '>= 5.0', '< 7.0'
  spec.add_dependency 'regexp-examples'
end
