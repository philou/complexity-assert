class Sampler
  def initialize(algo_under_test)
    @algo_under_test = algo_under_test
  end

  # Generates an array of sample data points
  # [ [input size, real time], ... ]
  def run(sizes, rounds)
    sizes.flat_map { |size | run_for_size(size, rounds) }
  end

  private

  def run_for_size(size, rounds)
    Array.new(rounds) do
      args = @algo_under_test.generate_args(size)
      GC.disable
      real_time = Benchmark.realtime { @algo_under_test.run(*args) }
      GC.enable
      [size, real_time]
    end
  end

end
