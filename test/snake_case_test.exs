defmodule SnakeCaseTest do
  use ExUnit.Case
  doctest SnakeCase

  @num_paths 184756

  test "simple single process" do
    assert SnakeCase.simple == @num_paths
  end

  test "simple multi process" do
    assert SnakeCase.simple_multi_process == @num_paths
  end

  test "optimized single process" do
    assert SnakeCase.optimized == @num_paths
  end

  test "optimized multi process" do
    assert SnakeCase.optimized_multi_process == @num_paths
  end

  test "iterative" do
    assert SnakeCase.iterative == @num_paths
  end

  test "factorial" do
    assert SnakeCase.factorial == @num_paths
  end

  test "Pascal's triangle" do
    assert SnakeCase.pascal == @num_paths
  end

  test "Timer benchmark" do
    SnakeCase.timer_benchmark
  end
end
