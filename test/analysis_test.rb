require_relative 'test_helper'

# Fast tests for the framework agnostic core, these do not benchmark anything
class AnalysisTest < Minitest::Test

  def test_complexities_are_ordered_from_the_cheapest_to_the_most_expensive
    assert_equal ['O(1)', 'O(n)', 'O(n^2)'], ComplexityAssert::Analysis::COMPLEXITIES
  end

  def test_complexities_at_most_includes_the_expected_one_and_the_better_ones
    assert_equal ['O(1)'], ComplexityAssert::Analysis.complexities_at_most('O(1)')
    assert_equal ['O(1)', 'O(n)'], ComplexityAssert::Analysis.complexities_at_most('O(n)')
    assert_equal ['O(1)', 'O(n)', 'O(n^2)'], ComplexityAssert::Analysis.complexities_at_most('O(n^2)')
  end

  def test_it_favors_simpler_models_to_fight_overfitting
    assert_equal 'O(1)', ComplexityAssert::Analysis.best_complexity_by_rmse(
      [['O(1)', 1.0], ['O(n)', 0.9], ['O(n^2)', 0.8]])
  end

  def test_it_picks_a_more_elaborate_model_when_it_is_twice_as_good
    assert_equal 'O(n)', ComplexityAssert::Analysis.best_complexity_by_rmse(
      [['O(1)', 1.0], ['O(n)', 0.1], ['O(n^2)', 0.09]])
  end
end
