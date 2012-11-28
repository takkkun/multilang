# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multilang/version'

Gem::Specification.new do |gem|
  gem.name          = 'multilang'
  gem.version       = Multilang::VERSION
  gem.authors       = ['Takahiro Kondo']
  gem.email         = ['heartery@gmail.com']
  gem.description   = %q{Support multilingualization}
  gem.summary       = %q{Foundation for multilingualization}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('nokogiri')
end
