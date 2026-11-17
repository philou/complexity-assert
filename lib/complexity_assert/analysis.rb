module ComplexityAssert

  # Framework agnostic complexity identification.
  #
  # This is the engine behind both the RSpec matchers (complexity_assert/matchers)
  # and the Minitest assertions (complexity_assert/minitest).
  module Analysis

    # Input sizes used both to fit and to validate the complexity models
    SAMPLE_SIZES = [8, 10, 12, 80, 100, 120, 800, 1000, 1200]
    SAMPLE_ROUNDS = 10
    WARMUP_ROUNDS = 60

    # From the simplest to the most expensive complexity
    MODELS = [
      ConstantComplexityModel,
      LinearComplexityModel,
      QuadraticComplexityModel
    ]

    # The big O notations of MODELS, in the same order
    COMPLEXITIES = MODELS.map { |model| model.new.to_s }

    # Identifies the complexity of algo, as one of COMPLEXITIES.
    #
    # algo has to respond to:
    # - generate_args(size) : returns the arguments of a run on an input of that size
    # - run(*args) : the code under test, its duration is what gets measured
    def self.identify_complexity(algo)
      sampler = WarmupSampler.new(Sampler.new(algo), WARMUP_ROUNDS)
      timings = sampler.run(SAMPLE_SIZES, SAMPLE_ROUNDS)

      complexity_models = MODELS.map(&:new)
      complexity_models.each { |model| model.analyze(timings) }

      validator = ComplexityValidator.new(sampler, complexity_models)

      best_complexity_by_rmse(validator.rmses)
    end

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

    # All the complexities that are as good as, or better than, complexity
    def self.complexities_at_most(complexity)
      index = COMPLEXITIES.index(complexity)
      raise ArgumentError, "Unknown complexity #{complexity.inspect}" unless index
      COMPLEXITIES.take(index + 1)
    end

    # True when algo runs in complexity, or better
    def self.at_most?(algo, complexity)
      complexities_at_most(complexity).include?(identify_complexity(algo))
    end

    def self.failure_message(algo, expected, actual)
      "expect that #{algo} would have a complexity equal or better than #{expected} but was #{actual}"
    end

    def self.negative_failure_message(algo, expected, actual)
      "expect that #{algo} would have a complexity worse than #{expected} but was #{actual}"
    end
  end
end
