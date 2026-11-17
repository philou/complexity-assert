require 'rspec/expectations'
require 'complexity_assert/core'

module ComplexityAssert

  # Kept for backward compatibility, Analysis is the real thing now
  class Matchers
    def self.best_complexity_by_rmse(complexity_errors)
      Analysis.best_complexity_by_rmse(complexity_errors)
    end

    def self.identify_complexity(algo)
      Analysis.identify_complexity(algo)
    end
  end

  {
    be_constant: 'O(1)',
    be_linear: 'O(n)',
    be_quadratic: 'O(n^2)'
  }.each do |matcher_name, expected_complexity|

    RSpec::Matchers.define matcher_name do
      match do |actual|
        @actual_complexity = Analysis.identify_complexity(actual)
        Analysis.complexities_at_most(expected_complexity).include?(@actual_complexity)
      end
      failure_message do |actual|
        Analysis.failure_message(actual, expected_complexity, @actual_complexity)
      end
      failure_message_when_negated do |actual|
        Analysis.negative_failure_message(actual, expected_complexity, @actual_complexity)
      end
    end
  end
end
