# computes the average of the time spent in order to predict future execution time
class ConstantComplexityModel

  def analyze(timings)
    sum = timings.map { |size_runtime| size_runtime[1] }.inject &:+
    @average = sum / timings.size
  end

  def predict_run_time(input_data_size)
    @average
  end

  def to_s
    'O(1)'
  end

end
