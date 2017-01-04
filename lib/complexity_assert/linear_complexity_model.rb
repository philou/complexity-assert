module ComplexityAssert
  # Generates a sample of execution timings to run a linear regression in order to predict another execution time
  class LinearComplexityModel

    def analyze(timings)
      linear_model = SimpleLinearRegression.new(*timings.transpose)
      @slope = linear_model.slope
      @y_intercept = linear_model.y_intercept
    end

    def predict_run_time(input_data_size)
      @y_intercept + @slope * input_data_size
    end

    def to_s
      "O(n)"
    end

  end

end
