require_relative 'test_helper'

class ComplexityAssertTest < Minitest::Test

  def test_it_has_a_version_number
    refute_nil ComplexityAssert::VERSION
  end

  def test_it_detects_that_random_5_is_constant
    assert_constant_complexity Random5.new
  end

  def test_it_detects_that_linear_search_is_linear
    assert_linear_complexity LinearSearch.new
  end

  def test_it_detects_that_linear_search_is_not_constant
    error = assert_raises(Minitest::Assertion) do
      assert_constant_complexity LinearSearch.new
    end
    assert_match(/complexity equal or better than O\(1\) but was O\(n\)/, error.message)
  end

  def test_it_detects_that_pairs_matching_is_quadratic
    assert_quadratic_complexity Pairs.new
  end

  def test_refute_rejects_a_complexity_that_is_good_enough
    error = assert_raises(Minitest::Assertion) do
      refute_linear_complexity LinearSearch.new
    end
    assert_match(/complexity worse than O\(n\) but was O\(n\)/, error.message)
  end

  def test_it_supports_a_custom_failure_message
    error = assert_raises(Minitest::Assertion) do
      assert_constant_complexity LinearSearch.new, 'search should not depend on the input size'
    end
    assert_match(/search should not depend on the input size/, error.message)
  end

  def test_it_rejects_an_unknown_complexity
    assert_raises(ArgumentError) do
      assert_complexity_at_most 'O(log n)', Random5.new
    end
  end
end
