# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'complexity_assert/version'

Gem::Specification.new do |spec|
  spec.name          = "complexity_assert"
  spec.version       = ComplexityAssert::VERSION
  spec.authors       = ["Philippe Bourgau"]
  spec.email         = ["philippe.bourgau@gmail.com"]

  spec.summary       = %q{An experimental rspec library to check the time complexity (Big O(x) notation) of an algorithm.}
  spec.description   = %q{They are some performance critical pieces of code that will be executed on huge data sets, which we want to make sure will run fast enough. Unfortunately, enforcing this is not easy, often requiring large scale and slow benchmarks. This rspec library (the result of an experiment to learn machine learning) uses linear regression to determine the time complexity (Big O notation, O(x)) of a piece of code and to check that it is at least as good as what we expect. This does not require huge data sets (only a few large ones) and can be written as any unit test (not as fast though).}
  spec.homepage      = "https://github.com/philou/complexity-assert"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://mygemserver.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 3.5

  spec.add_development_dependency "bundler", ">= 1.12"
  spec.add_development_dependency "rake", ">= 10.0"
end
