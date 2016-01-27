class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    @rationals = []
    direction = numerator = denominator = 1

    while @rationals.count < @limit
      next_rational_number = Rational(numerator, denominator)
      unless @rationals.include? next_rational_number
        @rationals.push(next_rational_number)
        yield next_rational_number
      end

      iteration = iterate_rational(direction, numerator, denominator)
      direction, numerator, denominator = iteration
    end
  end

  private

  def iterate_rational(direction, numerator, denominator)
    if direction == 1
      numerator += 1
      denominator > 1 ? denominator -= 1 : direction *= -1
    else
      denominator += 1
      numerator > 1 ? numerator -= 1 : direction *= -1
    end

    return direction, numerator, denominator
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    current, following = @first, @second

    (0...@limit).each do
      yield current
      current, following = following, current + following
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    prime_count = 0
    number = 2

    while prime_count < @limit
      if DrunkenMathematician.prime? number
        prime_count += 1
        yield number
      end

      number += 1
    end
  end
end


module DrunkenMathematician
  module_function

  def prime?(number)
    return false if number <= 1
    Math.sqrt(number).to_i.downto(2).each do
      |i| return false if number % i == 0
    end
  end

  def meaningless(n)
    partitions = RationalSequence.new(n).partition do |rational_number|
      prime?(rational_number.numerator) || prime?(rational_number.denominator)
    end

    first_partition_product = partitions[0].reduce(:*) || 1
    second_partition_product = partitions[1].reduce(:*) || 1

    first_partition_product / second_partition_product
  end

  def aimless(n)
    rational_primes = PrimeSequence.new(n).each_slice(2).map do |prime|
      Rational(prime[0], prime[1] || 1)
    end

    rational_primes.reduce(:+) || 0
  end

  def worthless(n)
    n_fibonacci = FibonacciSequence.new(n).take(n).last || 0
    max_slice = []
    max_slice_sum = slice_size = 0

    loop do
      slice = RationalSequence.new(slice_size)
      slice_sum = slice.reduce(0, :+)

      break if slice_sum > n_fibonacci

      if max_slice_sum < slice_sum
        max_slice = slice
        max_slice_sum = slice_sum
      end

      slice_size += 1
    end

    max_slice.to_a
  end
end
