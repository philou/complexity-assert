require 'benchmark'
require_relative 'simple_linear_regression'
require_relative 'sampler'
require_relative 'warmup_sampler'
require_relative 'constant_complexity_model'
require_relative 'linear_complexity_model'
require_relative 'quadratic_complexity_model'
require_relative 'complexity_validator'
require_relative 'algorithms'

algo = Pairs.new
sampler = WarmupSampler.new(Sampler.new(algo),60)
timings = sampler.run([8,10,12,80,100,120,800,1000,1200], 10)
complexity_models = [
  ConstantComplexityModel.new(),
  LinearComplexityModel.new(),
  QuadraticComplexityModel.new()
]

complexity_models.each { |model| model.analyze(timings) }
validator = ComplexityValidator.new(sampler, complexity_models)

rmses = validator.rmses

# complexity_errors : [["big O notation", rmse score], ...]
def complexity(complexity_errors)
  best = complexity_errors.first
  complexity_errors.drop(1).each do |comp_error|
    if comp_error[1] < best[1] / 2
      best = comp_error
    end
  end
  best[0]
end

puts "#{rmses.inspect} most likely : #{complexity(rmses)}"
