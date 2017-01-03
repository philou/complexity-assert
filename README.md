# ComplexityAssert

They are some performance critical pieces of code that will be executed on huge data sets, which we want to make sure will run fast enough. Unfortunately, enforcing this is not easy, often requiring large scale and slow benchmarks. This rspec library (the result of an experiment to learn machine learning) uses linear regression to determine the time complexity (Big O notation, O(x)) of a piece of code and to check that it is at least as good as what we expect. This does not require huge data sets (only a few large ones) and can be written as any unit test (not as fast though).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'complexity_assert', :group => [:test]
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install complexity_assert

## Usage

In order to test the complexity of an algorithm, you need to provide 2 things :

1. the algorithm
2. a way to generate some inputs of varying size

For this, you need to provide an object that answers to messages `generate_args` and `run`. Here is an example

``` ruby
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

describe "Linear search" do

    it "performs linearly" do
        expect(LinearSearch.new).to be_linear()
    end

end
```

There are currently 3 matchers :

* be_constant
* be_linear
* be_quadratic

More could be added in the future. Every matcher passes if a faster complexity is identified (`be_linear` willalso pass if the algorithm is detected to be constant).

That means that for the moment, `be_quadratic` always passes, but might turn out useful when we add more complex models (Internally, it is quite useful, as it is used to identify that something is more linear than quadratic !).

## Development

It uses rubybox, simply clone this repo, build the image, and start on.

```
git clone ...
cd ...
docker-compose build
docker-compose run rubybox
```

From then on, you're inside the ruby box, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/complexity_assert.

Here is a quick and uncomplete list of things that could improve this library :

* Cache the linear regression (it's done twice)
* Factorize / find a way to better generate the sizes, or allow the assertion to specify the sizes
* Allow the assertion to specify the warmup and run rounds
* Robustness against GC : use gc intensive ruby methods, and see how the regression behaves
* O(lnx) : pre-treat with exp()
* O(?lnx) : use exp, then a search for the coefficient (aka polynomial)
* O(xlnx) : there is no well known inverse for that, we can compute it numericaly though
* O(x?) : do some kind of dichotomy or search to find the most probable model
* Estimate how much the assert is deterministic
* ...

As I said, this is still experimental ! Any help is welcome !

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
