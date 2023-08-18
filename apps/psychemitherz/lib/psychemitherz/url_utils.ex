defmodule UrlUtils do
  @spec remove_schema_and_subdomains(String.t()) :: String.t()
  def remove_schema_and_subdomains(url) do
    %URI{host: host} = URI.parse(url)
    parts = String.split(host, ".", trim: true)

    case length(parts) do
      n when n <= 2 -> host
      _ -> Enum.reverse(parts) |> Enum.take(2) |> Enum.reverse() |> Enum.join(".")
    end
  end
end
