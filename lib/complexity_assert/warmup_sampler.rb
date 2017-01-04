module ComplexityAssert

  # A sampler wrapper that does some warmup on the algo under test
  class WarmupSampler
    def initialize(sampler, rounds)
      @sampler = sampler
      @rounds = rounds
    end

    def run(sizes, count)
      _warmup_data = @sampler.run(sizes,@rounds)
      @sampler.run(sizes,count)
    end
  end
end
