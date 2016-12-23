# A sampler wrapper that does some warmup on the algo under test
class WarmupSampler
  def initialize(sampler)
    @sampler = sampler
  end

  def run(sizes, count)
    _warmup_data = @sampler.run(sizes,3)
    @sampler.run(sizes,count)
  end
end
