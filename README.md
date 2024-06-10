# Sort Struct By Keys

Sort any structs given a list of keys to sort them.

## Problem

Given a list of struct, sort it by some keys with a custom comparator for each.
Start with the first key in the list and sort the list with the provided
comparator of that list. If the comparator returns the two value are equal, use
the next key to continue sorting the list.

For example, given a struct with keys `birth_year`, `birth_month`, `birth_day`,
we could specify to first sort by `birth_year`, if equal then sort by
`birth_month`, and if equal again then sort by `birth_day`.

## Overview

Specify a list of map, each map specify how to sort the structs. The map specify
3 fields:

1. `key`
   - Specify which key in the struct to sort with
   - For example, `:a` is specified, then `struct[:a]` will be used to sort the list
2. `comparator`:
   - Specify the comparator for the value, should return `:eq | :lt | :gt`
   - Only when the comparator returns `:eq` the sorter will use the next key to sort the list
3. `order`:
   - The order, either `:asc | :desc`

For example, sorting a list of structs by two dates field in the struct:

```elixir
sort_by_keys = [
  %{
    key: :a,
    comparator: &DateTime.compare/2,
    order: :asc
  },
  %{
    key: :b,
    comparator: &DateTime.compare/2,
    order: :desc
  },
]
```

- First sort by key `:a` in ascending order
- If the value of key `:a` is equal, sort by key `:b` in descending order

Then, sort the list by providing how to sort:

```elixir
Enum.sort(list, &SortByKeys.sorter(&1, &2, sort_by_keys))
```

## Running the code

```
elixir sort_by_keys.exs
```
