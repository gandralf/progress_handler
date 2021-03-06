# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'progress_handler/version'

Gem::Specification.new do |spec|
  spec.name          = 'progress_handler'
  spec.version       = ProgressHandler::VERSION
  spec.authors       = ['Alexandre Gandra Lages']
  spec.email         = ['gandra@gmail.com']

  spec.summary       = %q{Tool to see what is going on a background task}
  spec.description   = %q{Follow the progress of a iterative, background job}
  spec.homepage      = 'http://www.facebook.com/cracolandia-do-anticast'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'redis'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
end
