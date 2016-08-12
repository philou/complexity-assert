require 'benchmark'
require_relative 'simple-linear-regression'

def linear_search(array, searched)
  found = false;
  array.each do |element|
    if element == array
      found = true
    end
  end
  found
end

def generate_args(size)
  [ Array.new(size) { rand(1..size) }, rand(1..size) ]
end

def generate_data_for_size(size, count)
  Array.new(count) do
    array, searched = generate_args(size)
    GC.disable
    real_time = Benchmark.realtime { linear_search(array, searched) }
    GC.enable
    [size, real_time]
  end
end

def generate_data(sizes, count)
  sizes.flat_map { |size | generate_data_for_size(size, count) }
end

data = generate_data([8,10,12,80,100,120,800,1000,1200],10)

linear_model = SimpleLinearRegression.new(*data.transpose)

puts "Model generated with"
puts "Slope: #{linear_model.slope}"
puts "Y-Intercept: #{linear_model.y_intercept}"
puts "\n"
puts "Estimated Linear Model:"
puts "Y = #{linear_model.y_intercept} + (#{linear_model.slope} * X)"
