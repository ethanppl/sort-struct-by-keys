defmodule SortByKeys do
  def sorter(a, b, sort_by_keys) do
    Enum.reduce_while(sort_by_keys, true, fn %{
                                               key: key
                                             } = input,
                                             _acc ->
      comparator =
        Map.get(input, :comparator, fn a, b ->
          cond do
            a == b -> :eq
            a < b -> :lt
            a > b -> :gt
          end
        end)

      order = Map.get(input, :order, :asc)

      case {order, comparator.(a[key], b[key])} do
        {_any_order, :eq} -> {:cont, true}
        {:asc, :lt} -> {:halt, true}
        {:asc, :gt} -> {:halt, false}
        {:desc, :lt} -> {:halt, false}
        {:desc, :gt} -> {:halt, true}
      end
    end)
  end
end

date_1 = DateTime.utc_now()
date_2 = DateTime.utc_now() |> DateTime.add(1, :day)
date_3 = DateTime.utc_now() |> DateTime.add(2, :day)

to_sort = [
  %{
    name: "1",
    a: date_2,
    b: date_3,
    c: date_2,
    d: 1
  },
  %{
    name: "2",
    a: date_1,
    b: date_2,
    c: date_3,
    d: 2
  },
  %{
    name: "3",
    a: date_1,
    b: date_2,
    c: date_3,
    d: 1
  }
]

sort_by_keys = [
  %{
    key: :b,
    comparator: &DateTime.compare/2,
    order: :asc
  },
  %{
    key: :a,
    comparator: &DateTime.compare/2
  },
  %{
    key: :c,
    comparator: &DateTime.compare/2
  },
  %{
    key: :d,
    order: :desc
  }
]

to_sort
|> Enum.sort(&SortByKeys.sorter(&1, &2, sort_by_keys))
|> Enum.map(&Map.get(&1, :name))
|> IO.inspect()
