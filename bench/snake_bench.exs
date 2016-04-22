
defmodule SnakeBench do
  use Benchfella

  bench "Brute Force single process" do
    SnakeCase.simple
  end

  bench "Brute Force multi-process" do
    SnakeCase.simple_multi_process
  end

  bench "Brute Force optimized single process" do
    SnakeCase.optimized
  end

  bench "Brute Force optimized multi-process" do
    SnakeCase.optimized_multi_process
  end

  bench "Iterative" do
    SnakeCase.iterative
  end

  bench "Factorial" do
    SnakeCase.factorial
  end

  bench "Pascal's Triangle" do
    SnakeCase.pascal
  end
end
