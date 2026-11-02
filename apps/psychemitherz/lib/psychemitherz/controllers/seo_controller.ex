defmodule Psychemitherz.SeoController do
  use Psychemitherz, :controller

  alias Psychemitherz.SEO

  def sitemap(conn, _params) do
    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, SEO.sitemap_xml())
  end
end
