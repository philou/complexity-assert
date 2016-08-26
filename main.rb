require 'benchmark'
require_relative 'simple-linear-regression'
require_relative 'sampler'
require_relative 'linear_complexity_model'
require_relative 'complexity_validator'

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

linear_search = LinearSearch.new
sampler = Sampler.new(linear_search)
complexity_models = [1,10,20].map{ |run_count| LinearComplexityModel.new(sampler, run_count) }

complexity_models.each { |model| model.analyze() }
validator = ComplexityValidator.new(sampler, complexity_models)

rmses = validator.rmses
min_rmse = rmses.min
rmses_ratios = rmses.map {|rmse| (rmse / min_rmse).round(1) }
puts "#{rmses_ratios}"
