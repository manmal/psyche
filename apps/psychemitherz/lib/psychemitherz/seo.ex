defmodule Psychemitherz.SEO do
  @moduledoc """
  Defines the public pages and their search metadata.

  The page list is also the source for the XML sitemap.
  """

  import Psychemitherz.ContactData

  @origin "https://psychemitherz.at"
  @language "de-AT"
  @social_image_path "/images/logo_full_small.png"

  @pages [
    %{
      key: :home,
      path: "/",
      title: "Psychemitherz | Psychotherapie und Psychologie",
      description: "Psychotherapie und Psychologie mit Mag.a Bianca Maly in Wiener Neustadt."
    },
    %{
      key: :about,
      path: "/uebermich",
      title: "Über mich | Mag.a Bianca Maly | Psychemitherz",
      description:
        "Mag.a Bianca Maly stellt sich vor: Psychotherapeutin und Psychologin in Wiener Neustadt."
    },
    %{
      key: :therapy,
      path: "/therapie",
      title: "Therapeutische Angebote | Psychemitherz",
      description:
        "Systemische Einzeltherapie, Paar- und Familientherapie, Gruppenangebote sowie Selbsterfahrung und Coaching."
    },
    %{
      key: :counseling,
      path: "/beratungen",
      title: "Beratungen und Kurse | Psychemitherz",
      description: "Beratungen und Kurse rund um Baby- und Kinderzeit von Mag.a Bianca Maly."
    },
    %{
      key: :contact,
      path: "/kontakt",
      title: "Kontakt | Mag.a Bianca Maly | Psychemitherz",
      description:
        "Kontakt zu Mag.a Bianca Maly in der Gemeinschaftspraxis Psychotherapie am Hauptplatz, Hauptplatz 16 / 13, 2700 Wiener Neustadt."
    }
  ]

  @doc "Returns the indexable public pages with their canonical URLs."
  def pages do
    Enum.map(@pages, fn page ->
      page
      |> Map.put(:canonical_url, canonical_url(page.path))
      |> Map.put(:language, @language)
      |> Map.put(:social_image, canonical_url(@social_image_path))
    end)
  end

  @doc "Returns metadata for one public page."
  def page(key) when is_atom(key) do
    case Enum.find(pages(), &(&1.key == key)) do
      nil -> raise ArgumentError, "unknown Psychemitherz SEO page: #{inspect(key)}"
      page -> Map.put(page, :structured_data, structured_data())
    end
  end

  @doc "Returns the canonical URL for a site path."
  def canonical_url(path), do: @origin <> path

  @doc "Returns the XML sitemap for all indexable public pages."
  def sitemap_xml do
    urls =
      pages()
      |> Enum.map_join("\n", fn page -> "  <url><loc>#{page.canonical_url}</loc></url>" end)

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    #{urls}
    </urlset>
    """
  end

  defp structured_data do
    %{
      "@context" => "https://schema.org",
      "@type" => "Person",
      "@id" => canonical_url("#bianca-maly"),
      "name" => full_name(),
      "jobTitle" => "Psychotherapeutin und Psychologin",
      "worksFor" => %{
        "@type" => "Organization",
        "name" => practice()
      },
      "email" => email(),
      "telephone" => phone(),
      "url" => website(),
      "image" => canonical_url("/images/bianca.jpg"),
      "address" => %{
        "@type" => "PostalAddress",
        "streetAddress" => street_and_number(),
        "postalCode" => postal_code(),
        "addressLocality" => city()
      },
      "sameAs" => [
        "https://www.instagram.com/psychemitherz/",
        "https://www.facebook.com/profile.php?id=100077709940441"
      ]
    }
  end
end
