require 'benchmark'
require_relative 'simple-linear-regression'

class LinearSearch

  def generate_args(size)
    [ Array.new(size) { rand(1..size) }, rand(1..size) ]
  end

  def run(array, searched)
    found = false;
    array.each do |element|
      if element == array
        found = true
      end
    end
    found
  end
end

class Sampler
  def initialize(algo_under_test)
    @algo_under_test = algo_under_test
  end

  def run(sizes, count)
    sizes.flat_map { |size | run_for_size(size, count) }
  end

  private

  def run_for_size(size, count)
    Array.new(count) do
      args = algo_under_test.generate_args(size)
      GC.disable
      real_time = Benchmark.realtime { algo_under_test.run(*args) }
      GC.enable
      [size, real_time]
    end
  end

  attr_reader :algo_under_test
end

class LinearComplexityModel

  def initialize(sampler)
    @sampler = sampler
  end

  def analyze()
    data = @sampler.run([8,10,12,80,100,120,800,1000,1200],10)

    linear_model = SimpleLinearRegression.new(*data.transpose)
    @slope = linear_model.slope
    @y_intercept = linear_model.y_intercept
    linear_model
  end

  def predict_run_time(input_data_size)
    @y_intercept + @slope * input_data_size
  end

end

class ComplexityValidator

  def initialize(sampler, complexity_model)
    @sampler = sampler
    @complexity_model = complexity_model
  end

  def rmse()
    data = @sampler.run([8,10,12,80,100,120,800,1000,1200],10)

    Math.sqrt(data.map { |size, real_time|
        (real_time - @complexity_model.predict_run_time(size))**2
    }.reduce &:+)
  end

end

linear_search = LinearSearch.new
sampler = Sampler.new(linear_search)
complexity_model = LinearComplexityModel.new(sampler)

linear_model = complexity_model.analyze()
validator = ComplexityValidator.new(sampler, complexity_model)

puts "Model generated with"
puts "Slope: #{linear_model.slope}"
puts "Y-Intercept: #{linear_model.y_intercept}"
puts "\n"
puts "Estimated Linear Model:"
puts "Y = #{linear_model.y_intercept} + (#{linear_model.slope} * X)"
puts "\n"
puts "Root meaned squared error:"
puts "RMSE = #{validator.rmse}"
