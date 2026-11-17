require "minitest"
require "minitest/test"
require 'complexity_assert/core'

module ComplexityAssert

  # Minitest assertions to check the time complexity (Big O notation) of an algorithm.
  #
  # They are mixed into Minitest::Test as soon as 'complexity_assert/minitest'
  # is required, so a test only has to do:
  #
  #   require 'complexity_assert/minitest'
  #
  #   class MySearchTest < Minitest::Test
  #     def test_it_is_linear
  #       assert_linear_complexity MySearch.new
  #     end
  #   end
  #
  # The algorithm passed to the assertions has to respond to:
  # - generate_args(size) : the arguments of a run on an input of that size,
  #   generating them is not part of the measured duration
  # - run(*args) : the code under test, its duration is what gets measured
  module Assertions

    # Asserts that algo runs in constant time, O(1)
    def assert_constant_complexity(algo, msg = nil)
      assert_complexity_at_most('O(1)', algo, msg)
    end

    # Asserts that algo runs in linear time or better, O(n)
    def assert_linear_complexity(algo, msg = nil)
      assert_complexity_at_most('O(n)', algo, msg)
    end

    # Asserts that algo runs in quadratic time or better, O(n^2)
    def assert_quadratic_complexity(algo, msg = nil)
      assert_complexity_at_most('O(n^2)', algo, msg)
    end

    # Asserts that algo does not run in constant time
    def refute_constant_complexity(algo, msg = nil)
      refute_complexity_at_most('O(1)', algo, msg)
    end

    # Asserts that algo does not run in linear time or better
    def refute_linear_complexity(algo, msg = nil)
      refute_complexity_at_most('O(n)', algo, msg)
    end

    # Asserts that algo does not run in quadratic time or better
    def refute_quadratic_complexity(algo, msg = nil)
      refute_complexity_at_most('O(n^2)', algo, msg)
    end

    # Asserts that algo runs in expected_complexity, or better.
    # expected_complexity is one of ComplexityAssert::Analysis::COMPLEXITIES
    def assert_complexity_at_most(expected_complexity, algo, msg = nil)
      actual_complexity = Analysis.identify_complexity(algo)
      acceptable = Analysis.complexities_at_most(expected_complexity)

      assert acceptable.include?(actual_complexity),
             message(msg) { Analysis.failure_message(algo, expected_complexity, actual_complexity) }
    end

    # Asserts that algo runs slower than expected_complexity
    def refute_complexity_at_most(expected_complexity, algo, msg = nil)
      actual_complexity = Analysis.identify_complexity(algo)
      acceptable = Analysis.complexities_at_most(expected_complexity)

      refute acceptable.include?(actual_complexity),
             message(msg) { Analysis.negative_failure_message(algo, expected_complexity, actual_complexity) }
    end
  end
end

module Minitest
  class Test
    include ComplexityAssert::Assertions
  end
end
