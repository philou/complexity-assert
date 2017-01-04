require 'rspec/expectations'

module ComplexityAssert

  class Matchers
    # complexity_errors : [["big O notation", rmse score], ...], in order of complexity costs
    def self.best_complexity_by_rmse(complexity_errors)
      best = complexity_errors.first
      complexity_errors.drop(1).each do |comp_error|

        # we favor simpler complexities to fight overfitting from more elaborate models
        if comp_error[1] < best[1] / 2
          best = comp_error
        end
      end
      best[0]
    end

    private

    def self.identify_complexity(algo)
      sampler = WarmupSampler.new(Sampler.new(algo),60)
      # These sizes are duplicated with the ComplexityValidator
      timings = sampler.run([8,10,12,80,100,120,800,1000,1200], 10)
      complexity_models = [
        ConstantComplexityModel.new(),
        LinearComplexityModel.new(),
        QuadraticComplexityModel.new()
      ]

      complexity_models.each { |model| model.analyze(timings) }
      validator = ComplexityValidator.new(sampler, complexity_models)

      rmses = validator.rmses

      best_complexity_by_rmse(rmses)
    end
  end

  # TODO
  # - factorize code of these matchers
  # - stop using the "O(x)" magic constants (they are the XXXComplexityModel.to_s)

  RSpec::Matchers.define :be_constant do
    match do |actual|
      @actual_complexity = Matchers.identify_complexity(actual)
      ["O(1)"].include?(@actual_complexity)
    end
    failure_message do |actual|
      "expect that #{actual} would have a complexity equal or better than O(1) but was #{@actual_complexity}"
    end
  end

  RSpec::Matchers.define :be_linear do
    match do |actual|
      @actual_complexity = Matchers.identify_complexity(actual)
      ["O(1)","O(n)"].include?(@actual_complexity)
    end
    failure_message do |actual|
      "expect that #{actual} would have a complexity equal or better than O(n) but was #{@actual_complexity}"
    end
  end

  RSpec::Matchers.define :be_quadratic do
    match do |actual|
      @actual_complexity = Matchers.identify_complexity(actual)
      ["O(1)","O(n)","O(n^2)"].include?(@actual_complexity)
    end
    failure_message do |actual|
      "expect that #{actual} would have a complexity equal or better than O(n^2) but was #{@actual_complexity}"
    end
  end
end
