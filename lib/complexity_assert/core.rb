# The framework agnostic part of the library. Requiring 'complexity_assert'
# loads this and hooks into the test framework that is already loaded, while the
# framework integrations only need this, which keeps the requires acyclic.
require "complexity_assert/version"

require "complexity_assert/complexity_validator"
require "complexity_assert/constant_complexity_model"
require "complexity_assert/linear_complexity_model"
require "complexity_assert/quadratic_complexity_model"
require "complexity_assert/sampler"
require "complexity_assert/simple_linear_regression"
require "complexity_assert/warmup_sampler"
require "complexity_assert/analysis"

module ComplexityAssert
  class << self
    # Identifies the complexity of algo, see Analysis.identify_complexity
    def identify_complexity(algo)
      Analysis.identify_complexity(algo)
    end
  end
end
