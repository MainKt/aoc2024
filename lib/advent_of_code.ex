defmodule AdventOfCode do
  def day1_part1 do
    File.stream!("inputs/day1")
    |> Stream.flat_map(&String.split/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
    |> Stream.map(&Enum.sort/1)
    |> Enum.zip_reduce(0, fn [a, b], acc -> acc + abs(a - b) end)
  end

  def day1_part2 do
    {left, right_frequencies} =
      File.stream!("inputs/day1")
      |> Stream.flat_map(&String.split/1)
      |> Stream.map(&String.to_integer/1)
      |> Stream.chunk_every(2)
      |> Stream.map(&List.to_tuple/1)
      |> Enum.unzip()
      |> update_elem(1, &Enum.frequencies/1)

    Stream.map(left, &(&1 * Map.get(right_frequencies, &1, 0)))
    |> Enum.sum()
  end

  defp update_elem(tuple, index, func), do: put_elem(tuple, index, func.(elem(tuple, index)))

  defp safe?(level) do
    (monotonic?(level, &>/2) or monotonic?(level, &</2)) and
      monotonic?(level, &(abs(&1 - &2) in 1..3))
  end

  defp monotonic?(enum, cmp) do
    enum
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> cmp.(a, b) end)
  end

  def day2_part1 do
    File.stream!("inputs/day2")
    |> Stream.map(&(String.split(&1) |> Enum.map(fn nums -> String.to_integer(nums) end)))
    |> Stream.filter(&safe?/1)
    |> Enum.count()
  end

  def day2_part2 do
    levels =
      File.stream!("inputs/day2")
      |> Stream.map(fn line ->
        line |> String.split() |> Stream.map(&String.to_integer/1)
      end)

    safe_levels = levels |> Stream.filter(&safe?/1) |> Enum.count()

    tolerated_levels =
      levels
      |> Stream.reject(&safe?/1)
      |> Stream.filter(fn level ->
        0..(Enum.count(level) - 1)
        |> Enum.any?(fn index ->
          List.delete_at(Enum.to_list(level), index) |> safe?()
        end)
      end)
      |> Enum.count()

    safe_levels + tolerated_levels
  end

  def day3_part1 do
    instructions = File.stream!("inputs/day3") |> Enum.join()

    ~r/mul\((\d+),(\d+)\)/
    |> Regex.scan(instructions)
    |> Stream.map(fn
      [_ | nums] -> nums |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
    |> Stream.map(&Tuple.product/1)
    |> Enum.sum()
  end

  def day3_part2 do
    instructions = File.stream!("inputs/day3") |> Enum.join()

    ~r/mul\((\d+),(\d+)\)|don\'t|do/
    |> Regex.scan(instructions)
    |> Stream.map(fn
      [cmd] -> cmd
      [_ | nums] -> nums |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
    |> Enum.reduce(
      {"do", 0},
      fn
        "do", {_, sum} -> {"do", sum}
        "don't", {_, sum} -> {"don't", sum}
        {a, b}, {"do", sum} -> {"do", a * b + sum}
        _, {"don't", sum} -> {"don't", sum}
      end
    )
    |> elem(1)
  end
end
