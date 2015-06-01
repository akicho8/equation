# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'equation/version'

Gem::Specification.new do |spec|
  spec.name          = "equation"
  spec.version       = Equation::VERSION
  spec.authors       = ["akicho8"]
  spec.email         = ["akicho8@gmail.com"]
  spec.description   = %q{x y interconversion library}
  spec.summary       = %q{x y interconversion library}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  # spec.add_development_dependency "stylet_math"
  # spec.add_development_dependency "rain_table"
  spec.add_development_dependency "gnuplot"
end
