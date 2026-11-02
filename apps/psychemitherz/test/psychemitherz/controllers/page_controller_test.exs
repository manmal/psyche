defmodule Psychemitherz.PageControllerTest do
  use Psychemitherz.ConnCase
  require Phoenix.LiveViewTest

  @public_pages Psychemitherz.SEO.pages()
  @therapy_card_paths %{
    home: [
      {"/images/systemische_einzeltherapie.png", "/images/systemische_einzeltherapie.webp", 370,
       234, 370, 234},
      {"/images/paar_familientherapie.png", "/images/paar_familientherapie.webp", 370, 202, 370,
       202},
      {"/images/gruppenangebote.png", "/images/gruppenangebote.webp", 392, 202, 392, 202},
      {"/images/selbsterfahrung_coaching.png", "/images/selbsterfahrung_coaching.webp", 392, 234,
       392, 234},
      {"/images/your_happy_family.png", "/images/your_happy_family.webp", 392, 202, 392, 202}
    ],
    therapy: [
      {"/images/systemische_einzeltherapie.png", "/images/systemische_einzeltherapie.webp", 370,
       234, 370, 234},
      {"/images/paar_familientherapie.png", "/images/paar_familientherapie.webp", 370, 202, 370,
       202},
      {"/images/gruppenangebote.png", "/images/gruppenangebote.webp", 392, 202, 392, 202},
      {"/images/selbsterfahrung_coaching.png", "/images/selbsterfahrung_coaching.webp", 392, 234,
       392, 234}
    ],
    counseling: [
      {"/images/your_happy_family.png", "/images/your_happy_family.webp", 392, 202, 392, 202}
    ]
  }

  test "GET / renders the homepage happy path", %{conn: conn} do
    conn = get(conn, ~p"/")
    document = Floki.parse_document!(html_response(conn, 200))
    page = Enum.find(@public_pages, &(&1.key == :home))

    assert Floki.text(Floki.find(document, "title")) == page.title
    assert Floki.attribute(document, "html", "lang") == ["de-AT"]
    assert Floki.attribute(document, "link[rel=canonical]", "href") == [page.canonical_url]
    assert length(Floki.find(document, "h1")) == 1
    assert length(Floki.find(document, "main")) == 1
    assert Floki.text(document) =~ "Mein Name ist Bianca Maly"
    refute Floki.text(document) =~ "Peace of mind from prototype to production"
  end

  test "public pages have unique German metadata and stable public responses", %{conn: conn} do
    rendered_pages =
      Enum.map(@public_pages, fn page ->
        conn = get(conn, page.path)
        document = Floki.parse_document!(html_response(conn, 200))

        assert public_phx_attributes(document) == []
        assert Floki.attribute(document, "link[rel=icon]", "href") == ["/favicon.ico"]
        assert Floki.attribute(document, "link[rel=stylesheet]", "phx-track-static") == []
        assert Floki.attribute(document, "script[src]", "phx-track-static") == []
        assert Floki.attribute(document, "script[src]", "type") == []

        assert Floki.attribute(document, "img[src='/images/logo_full_small.webp']", "src") == [
                 "/images/logo_full_small.webp"
               ]

        assert Floki.attribute(document, "span.text-green-900", "class") != []
        assert Floki.attribute(document, "span.text-green-700", "class") == []

        assert get_resp_header(conn, "content-language") == ["de-AT"]

        assert get_resp_header(conn, "cache-control") == [
                 "public, max-age=300, s-maxage=86400, stale-while-revalidate=604800"
               ]

        assert get_resp_header(conn, "set-cookie") == []
        assert Floki.attribute(document, "html", "lang") == ["de-AT"]
        assert Floki.attribute(document, "link[rel=canonical]", "href") == [page.canonical_url]

        assert Floki.attribute(document, "meta[name=description]", "content") == [
                 page.description
               ]

        assert Floki.attribute(document, "meta[property='og:title']", "content") == [page.title]

        assert Floki.attribute(document, "meta[property='og:description']", "content") == [
                 page.description
               ]

        assert Floki.attribute(document, "meta[property='og:url']", "content") == [
                 page.canonical_url
               ]

        assert Floki.attribute(document, "meta[property='og:image']", "content") == [
                 page.social_image
               ]

        assert length(Floki.find(document, "h1")) == 1
        assert [1 | subordinate_ranks] = heading_ranks(document)
        assert Enum.all?(subordinate_ranks, &(&1 == 2))
        assert length(Floki.find(document, "main")) == 1
        assert Floki.find(document, "meta[name=csrf-token]") == []
        refute Enum.member?(Floki.attribute(document, "a", "href"), "#")

        assert Floki.text(Floki.find(document, "title")) == page.title
        assert length(Floki.find(document, "script[type='application/ld+json']")) == 1

        [_, json_ld] =
          Regex.run(
            ~r/<script type="application\/ld\+json">\s*(\{.*\})\s*<\/script>/s,
            conn.resp_body
          )

        structured_data = Jason.decode!(json_ld)

        assert structured_data["@context"] == "https://schema.org"
        assert structured_data["name"] == "Mag.a Bianca Maly"
        assert structured_data["email"] == "praxis@psychemitherz.at"
        assert structured_data["url"] == "https://psychemitherz.at"

        page
      end)

    assert rendered_pages |> Enum.map(& &1.title) |> Enum.uniq() |> length() == 5
    assert rendered_pages |> Enum.map(& &1.description) |> Enum.uniq() |> length() == 5
  end

  test "therapy cards use separate WebP and PNG candidates on every public card route", %{
    conn: conn
  } do
    for page <- @public_pages, page.key in [:home, :therapy, :counseling] do
      document = conn |> get(page.path) |> html_response(200) |> Floki.parse_document!()
      expected_paths = Map.fetch!(@therapy_card_paths, page.key)
      actual_paths = therapy_card_paths(document)

      assert length(actual_paths) == length(expected_paths)
      assert Enum.sort(actual_paths) == Enum.sort(expected_paths)

      Enum.each(actual_paths, fn {png_path, webp_path, width, height, fallback_width,
                                  fallback_height} ->
        assert String.ends_with?(png_path, ".png")
        assert String.ends_with?(webp_path, ".webp")
        refute png_path == webp_path
        assert {width, height} == {fallback_width, fallback_height}
      end)
    end

    document = conn |> get("/") |> html_response(200) |> Floki.parse_document!()
    portrait = Floki.find(document, "picture[data-portrait]")
    assert length(portrait) == 1

    assert Floki.attribute(portrait, "source", "srcset") == [
             "/images/bianca-170.webp 170w, /images/bianca-340.webp 340w"
           ]

    assert Floki.attribute(portrait, "source", "sizes") == ["170px"]
    assert Floki.attribute(portrait, "img", "src") == ["/images/bianca.jpg"]
    assert Floki.attribute(portrait, "img", "width") == ["510"]
    assert Floki.attribute(portrait, "img", "height") == ["581"]
    assert Floki.attribute(portrait, "img", "alt") == ["Mag.a Bianca Maly"]
    assert Floki.attribute(portrait, "img", "loading") == ["lazy"]
  end

  test "therapy_box renders digested image paths with explicit dimensions" do
    png_path = "/images/systemische_einzeltherapie-deadbeef.png?vsn=d"
    webp_path = "/images/systemische_einzeltherapie-feedface.webp?vsn=d"

    rendered =
      Phoenix.LiveViewTest.render_component(&Psychemitherz.GlobalHtml.therapy_box/1,
        title: "Digest regression",
        bg_color: "bg-green-100",
        bg_image: png_path,
        bg_image_webp: webp_path,
        bg_image_width: 370,
        bg_image_height: 234
      )

    document = Floki.parse_fragment!(rendered)
    [source] = Floki.find(document, "source[type='image/webp']")
    [image] = Floki.find(document, "img")

    assert Floki.attribute(image, "src") == [png_path]
    assert Floki.attribute(source, "srcset") == [webp_path]
    assert Floki.attribute(source, "width") == ["370"]
    assert Floki.attribute(source, "height") == ["234"]
    assert Floki.attribute(image, "width") == ["370"]
    assert Floki.attribute(image, "height") == ["234"]
  end

  test "sitemap uses the public page metadata source", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/xml")
      |> get("/sitemap.xml")

    assert response(conn, 200) =~ "<urlset"

    urls =
      conn.resp_body
      |> Floki.parse_document!()
      |> Floki.find("loc")
      |> Enum.map(&Floki.text/1)

    assert Enum.sort(urls) == Enum.sort(Enum.map(@public_pages, & &1.canonical_url))
  end

  test "robots declares the sitemap and excludes non-indexable routes", %{conn: conn} do
    conn = get(conn, "/robots.txt")
    body = response(conn, 200)

    assert get_resp_header(conn, "cache-control") == ["public, max-age=0, must-revalidate"]
    assert get_resp_header(conn, "etag") != []
    refute "immutable" in get_resp_header(conn, "cache-control")

    versioned_conn = get(build_conn(), "/robots.txt?vsn=d")

    assert get_resp_header(versioned_conn, "cache-control") == [
             "public, max-age=31536000, immutable"
           ]

    assert get_resp_header(versioned_conn, "etag") == []

    assert body =~ "User-agent: *"
    assert body =~ "Allow: /"
    assert body =~ "Disallow: /dev"
    assert body =~ "Disallow: /vcard"
    assert body =~ "Sitemap: https://psychemitherz.at/sitemap.xml"
  end

  test "vcard is a downloadable non-indexable response", %{conn: conn} do
    conn = get(conn, ~p"/vcard")

    assert response(conn, 200) =~ "BEGIN:VCARD"
    assert get_resp_header(conn, "content-type") == ["text/vcard; charset=utf-8"]

    assert get_resp_header(conn, "content-disposition") == [
             "attachment; filename=\"bianca-maly.vcf\""
           ]

    assert get_resp_header(conn, "x-robots-tag") == ["noindex, nofollow"]
    assert get_resp_header(conn, "set-cookie") == []
  end

  defp heading_ranks(document) do
    document
    |> Floki.find("h1, h2, h3, h4, h5, h6")
    |> Enum.map(fn {tag, _, _} -> tag |> String.trim_leading("h") |> String.to_integer() end)
  end

  defp public_phx_attributes(document) do
    document
    |> Floki.find("*")
    |> Enum.flat_map(fn {_tag, attrs, _children} ->
      attrs
      |> Enum.map(fn {name, _value} -> name end)
      |> Enum.filter(&String.starts_with?(&1, "phx-"))
    end)
  end

  defp therapy_card_paths(document) do
    document
    |> Floki.find("picture[data-therapy-card]")
    |> Enum.map(fn picture ->
      [source] = Floki.find(picture, "source[type='image/webp']")
      [image] = Floki.find(picture, "img")
      assert Floki.attribute(source, "type") == ["image/webp"]
      assert Floki.attribute(image, "alt") == [""]
      assert Floki.attribute(image, "aria-hidden") == ["true"]

      {Floki.attribute(image, "src") |> List.first(),
       Floki.attribute(source, "srcset") |> List.first(),
       Floki.attribute(source, "width") |> List.first() |> String.to_integer(),
       Floki.attribute(source, "height") |> List.first() |> String.to_integer(),
       Floki.attribute(image, "width") |> List.first() |> String.to_integer(),
       Floki.attribute(image, "height") |> List.first() |> String.to_integer()}
    end)
  end
end
