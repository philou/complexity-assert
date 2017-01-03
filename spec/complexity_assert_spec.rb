require 'spec_helper'

require_relative 'algorithms'

describe ComplexityAssert do
  it 'has a version number' do
    expect(ComplexityAssert::VERSION).not_to be nil
  end

  it 'detects that linear search is linear' do
    algo = LinearSearch.new
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

    expect(complexity(rmses)).to eq("O(n)")
  end
end
