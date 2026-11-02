defmodule Psychemitherz.PageController do
  use Psychemitherz, :controller
  import Psychemitherz.ContactData

  alias Psychemitherz.SEO

  def home(conn, _params), do: render_page(conn, :home, :home)

  def about(conn, _params), do: render_page(conn, :about, :about)

  def therapy(conn, _params), do: render_page(conn, :therapy, :therapy)

  def counseling(conn, _params), do: render_page(conn, :counseling, :counseling)

  def contact(conn, _params), do: render_page(conn, :contact, :contact)

  def vcard(conn, _params) do
    priv_dir = :code.priv_dir(:psychemitherz)
    image_binary = File.read!("#{priv_dir}/static/images/bianca.jpg")
    base64_image = Base.encode64(image_binary)

    vcard_data = """
    BEGIN:VCARD
    VERSION:3.0
    FN:#{full_name()}
    N:Maly;Bianca;;Mag.a;
    ORG:#{org()}
    ADR;TYPE=WORK:;;#{street_and_number()};#{city()};;#{postal_code()};
    EMAIL;TYPE=WORK:#{email()}
    TEL;TYPE=WORK:#{phone()}
    URL:#{website()}
    PHOTO;ENCODING=b;TYPE=JPEG:#{base64_image}
    END:VCARD
    """

    conn
    |> put_resp_content_type("text/vcard")
    |> put_resp_header("content-disposition", ~s(attachment; filename="bianca-maly.vcf"))
    |> put_resp_header("x-robots-tag", "noindex, nofollow")
    |> send_resp(200, vcard_data)
  end

  defp render_page(conn, template, page_key) do
    render(conn, template, seo: SEO.page(page_key))
  end
end
