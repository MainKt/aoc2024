defmodule AdventOfCode do
  def day1_part1 do
    File.stream!("inputs/day1_part1")
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
      File.stream!("inputs/day1_part2")
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
end
