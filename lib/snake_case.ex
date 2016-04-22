defmodule SnakeCase do

  @range 0..round(:math.pow(2, 20)) 
  @doc """
  Simple Brute Force approach, single process.
  """
  def simple do
    Enum.count @range, fn x -> Integer.to_string(x, 2) |> String.replace("0", "") |> String.length == 10 end
  end

  @doc """
  Simple Brute Force approach, multi-process.
  """
  def simple_multi_process do
    Agent.start_link(fn -> 0 end, name: __MODULE__)

    ranges = Enum.chunk(@range, 262144)
    tasks = Enum.map(ranges, fn range ->
      Task.async(fn -> simple_subrange(range) end)
    end)

    for task <- tasks, do: Task.await(task)

    count = Agent.get(__MODULE__, fn x -> x end)
    Agent.stop(__MODULE__)
    count
  end

  defp simple_subrange(range) do
    count = Enum.count range, fn x -> Integer.to_string(x, 2) |> String.replace("0", "") |> String.length == 10 end
    Agent.update(__MODULE__, fn(n) -> n + count end)
  end

  @doc """
  Optimized Brute Force approach, single process.
  """
  def optimized do
    Enum.count(@range, fn x -> count_one_bits(:binary.encode_unsigned(x), 0) == 10 end)
  end

  @doc """
  Optmized Brute Force approach, multi-process.
  """
  def optimized_multi_process do
    Agent.start_link(fn -> 0 end, name: __MODULE__)

    ranges = Enum.chunk(@range, 262144)
    tasks =  Enum.map(ranges, fn range ->
      Task.async(fn -> optimized_subrange(range) end)
    end)
    
    for task <- tasks, do: Task.await(task)
    
    count = Agent.get(__MODULE__, fn x -> x end)
    Agent.stop(__MODULE__)
    count
  end

  defp optimized_subrange(range) do
    count = Enum.count(range, fn x -> count_one_bits(:binary.encode_unsigned(x), 0) == 10 end)
    Agent.update(__MODULE__, fn(n) -> n + count end)
  end

  # Thanks to @utkarshkukreti on Github & the Elixir Slack channel!
  defp count_one_bits(<<>>, acc), do: acc
  defp count_one_bits(<<n::1, rest :: bitstring>>, acc), do: count_one_bits(rest, acc + n)

  @doc """
  Iterative solution.
  """
  def iterative do
    _count_paths(10, 10)
  end

  defp _count_paths(0, _), do: 1
  defp _count_paths(_, 0), do: 1
  defp _count_paths(h, w), do: _count_paths(h-1, w) + _count_paths(h, w-1) 

  @doc """
  Factorial paths.
  """
  def factorial do
    _factorial_paths(10, 10)
  end

  defp _factorial_paths(h, w) do
    Enum.reduce((h+w)..(h+1), fn(x, acc) -> x * acc end) / Enum.reduce(w..1, fn(x, acc) -> x * acc end)
    |> round
  end

  @doc """
  Pascal Triangle solution.
  """
  def pascal do
    _pascal_paths(10, 10)
  end

  defp _pascal_paths(h, w) do
    # Build the first row:
    row = for _ <- 1..(w+1), do: 1

    # Process ALL the other rows:
    row
    |> _pascal_row(h)
    |> List.last
  end

  defp _pascal_row(row, h), do: _pascal_row(row, h, 0)
  defp _pascal_row(row, h, num) when num < h, do: Enum.reduce(row, [], &_pascal_acc/2) |> _pascal_row(h, num+1)
  defp _pascal_row(row, _h, _num), do: row

  defp _pascal_acc(x, []), do: [x]
  defp _pascal_acc(x, acc), do: acc ++ [x + List.last(acc)]

  @doc """
  Erlang timer benchmark method.
  """
  def timer_benchmark do
    {time, result} = :timer.tc fn -> SnakeCase.simple end
    IO.inspect "Brute force single: #{time}µs, result: #{result}"

    {time, result} = :timer.tc fn -> SnakeCase.simple_multi_process end
    IO.inspect "Brute force multi: #{time}µs, result: #{result}"

    {time, result} = :timer.tc fn -> SnakeCase.optimized end
    IO.inspect "Brute force optimized single: #{time}µs, result: #{result}"

    {time, result} = :timer.tc fn -> SnakeCase.optimized_multi_process end
    IO.inspect "Brute force optimized multi: #{time}µs, result: #{result}"
    
    {time, result} = :timer.tc fn -> SnakeCase.iterative end
    IO.inspect "Iterative: #{time}µs, result: #{result}"
 
    {time, result} = :timer.tc fn -> SnakeCase.factorial end
    IO.inspect "Factorial: #{time}µs, result: #{result}"
 
    {time, result} = :timer.tc fn -> SnakeCase.pascal end
    IO.inspect "Pascal's Triangle: #{time}µs, result: #{result}"

  end
end
