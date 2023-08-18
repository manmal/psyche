defmodule Slugify do
  @spec to_slug(String.t()) :: String.t()
  def to_slug(text) do
    replace_special_chars = fn str -> Regex.replace(~r/[^\w\s-]/, str, "") end
    replace_multiple_dashes = fn str -> Regex.replace(~r/-{2,}/, str, "-") end

    text
    |> String.downcase()
    |> String.trim()
    |> replace_special_chars.()
    |> String.split()
    |> Enum.map(&URI.encode/1)
    |> Enum.join("-")
    |> replace_multiple_dashes.()
  end
end
