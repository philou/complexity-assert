require 'spec_helper'

require_relative 'algorithms'
require 'rspec/expectations'

# complexity_errors : [["big O notation", rmse score], ...]
def best_complexity_by_rmse(complexity_errors)
  best = complexity_errors.first
  complexity_errors.drop(1).each do |comp_error|
    if comp_error[1] < best[1] / 2
      best = comp_error
    end
  end
  best[0]
end

def identify_complexity(algo)
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

  best_complexity_by_rmse(rmses)
end

RSpec::Matchers.define :be_constant do
  match do |actual|
    @actual_complexity = identify_complexity(actual)
    ["O(1)"].include?(@actual_complexity)
  end
  failure_message do |actual|
    "expect that #{actual} would have a complexity equal or better than O(1) but was #{@actual_complexity}"
  end
end

RSpec::Matchers.define :be_linear do
  match do |actual|
    @actual_complexity = identify_complexity(actual)
    ["O(1)","O(n)"].include?(@actual_complexity)
  end
  failure_message do |actual|
    "expect that #{actual} would have a complexity equal or better than O(n) but was #{@actual_complexity}"
  end
end

RSpec::Matchers.define :be_quadratic do
  match do |actual|
    @actual_complexity = identify_complexity(actual)
    ["O(1)","O(n)","O(n^2)"].include?(@actual_complexity)
  end
  failure_message do |actual|
    "expect that #{actual} would have a complexity equal or better than O(n^2) but was #{@actual_complexity}"
  end
end

describe ComplexityAssert do
  it 'has a version number' do
    expect(ComplexityAssert::VERSION).not_to be nil
  end

  it 'detects that random 5 is constant' do
    expect(Random5.new).to be_constant
  end

  it 'detects that linear search is linear' do
    expect(LinearSearch.new).to be_linear
  end

  it 'detects that linear search is not constant' do
    expect { expect(LinearSearch.new).to be_constant }.to(
      raise_error(/expect that .* would have a complexity equal or better than O\(1\) but was O\(n\)/))
  end

  it 'detects that pairs matching is quadratic' do
    expect(Pairs.new).to be_quadratic
  end
end
