# a known linear algorithm to be benchmarked
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

# a constant linear algorithm to be benchmarked
class Random5

  def generate_args(size)
    [ Array.new(size) { rand(1..size) } ]
  end

  def run(array)
    (0...5).each do |i|
      r = rand(i...array.length)
      array[i], array[r] = array[r], array[i]
    end
    array[0...5]
  end
end

class Pairs

  def generate_args(size)
    [ Array.new(size) { rand(1..size) } ]
  end

  def run(array)
    pairs = 0
    array.each_index do |i|
      (i+1...array.size).each do |j|
        if i == j
          pairs += 1
        end
      end
    end
    pairs
  end
end
