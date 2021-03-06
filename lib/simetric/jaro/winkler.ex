defmodule Simetric.Jaro.Winkler do
  @moduledoc """
  An implementation of the [Jaro–Winkler](http://en.wikipedia.org/wiki/Jaro–Winkler_distance) distance metric.

  It is designed and best-suited for short strings such as person names.
  """

  @doc """
  Returns a float value between 0 (equates to no similarity) and 1 (is an exact match)
  representing a distance between `str1` and `str2`.

  ## Examples

      iex> Simetric.Jaro.Winkler.compare("dwayne", "duane")
      0.8400000000000001
      iex> Simetric.Jaro.Winkler.compare("even", "odd")
      0.0

  """
  @spec compare(String.t, String.t) :: 0..1

  def compare(str1, str2) do
    case Simetric.Jaro.compare(str1, str2) do
      0.0 -> 0.0
      1.0 -> 1.0
      dist ->
        dist + (prefix(str1, str2) * 0.1 * (1 - dist))
    end
  end

  defp prefix(str1, str2) do
    prefix(str1, str2, 0, 4)
  end

  defp prefix(_str1, _str2, count, 0), do: count
  defp prefix(_str, "", count, _lim),  do: count
  defp prefix("", _str, count, _lim),  do: count

  defp prefix(str1, str2, count, lim) do
    {char, rest1} = String.next_grapheme(str1)

    case String.next_grapheme(str2) do
      {^char, rest2} ->
        prefix(rest1, rest2, count + 1, lim - 1)

      {_, _} -> count
    end
  end
end
