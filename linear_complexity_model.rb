class LinearComplexityModel

  def initialize(sampler, run_count)
    @sampler = sampler
    @run_count = run_count
  end

  def analyze()
    data = @sampler.run([8,10,12,80,100,120,800,1000,1200], @run_count)

    linear_model = SimpleLinearRegression.new(*data.transpose)
    @slope = linear_model.slope
    @y_intercept = linear_model.y_intercept
    linear_model
  end

  def predict_run_time(input_data_size)
    @y_intercept + @slope * input_data_size
  end

end
