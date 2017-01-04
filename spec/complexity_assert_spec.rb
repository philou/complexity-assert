require 'spec_helper'

require_relative 'algorithms'

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
