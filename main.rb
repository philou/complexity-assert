require 'benchmark'
require_relative 'simple_linear_regression'
require_relative 'sampler'
require_relative 'warmup_sampler'
require_relative 'linear_complexity_model'
require_relative 'constant_complexity_model'
require_relative 'complexity_validator'
require_relative 'algorithms'

algo = Random5.new
sampler = WarmupSampler.new(Sampler.new(algo),60)
timings = sampler.run([8,10,12,80,100,120,800,1000,1200], 10)
complexity_models = [
  LinearComplexityModel.new(),
  ConstantComplexityModel.new()
]

complexity_models.each { |model| model.analyze(timings) }
validator = ComplexityValidator.new(sampler, complexity_models)

rmses = validator.rmses
min_rmse = rmses.min
rmses_ratios = rmses.map {|rmse| (rmse / min_rmse).round(1) }
#puts "#{rmses_ratios}"

#puts rmses.join(",")

l_err, c_err = rmses
best = if l_err < c_err / 2
         'linear'
       else
         'constant'
       end

puts "#{l_err}, #{c_err}, #{best}"
