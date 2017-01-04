module ComplexityAssert

  # Generates a sample of execution timings to run a linear regression in order to predict another execution time
  class QuadraticComplexityModel

    # timings : [[size,timing], ...]
    def analyze(timings)
      sqrt_timings = timings.map do |size, timing|
        [size, Math.sqrt(timing)]
      end
      linear_model = SimpleLinearRegression.new(*sqrt_timings.transpose)
      sqrt_slope = linear_model.slope
      sqrt_y_intercept = linear_model.y_intercept

      @quadratic = sqrt_slope * sqrt_slope
      @slope = 2* sqrt_slope * sqrt_y_intercept
      @y_intercept = sqrt_y_intercept * sqrt_y_intercept
    end

    def predict_run_time(input_data_size)
      @y_intercept + @slope * input_data_size + @quadratic * input_data_size * input_data_size
    end

    def to_s
      'O(n^2)'
    end

  end

end
