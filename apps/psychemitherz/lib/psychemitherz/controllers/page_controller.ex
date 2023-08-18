defmodule Psychemitherz.PageController do
  use Psychemitherz, :controller
  import Psychemitherz.ContactData

  def home(conn, _params) do
    render(conn, :home)
  end

  def about(conn, _params) do
    render(conn, :about)
  end

  def therapy(conn, _params) do
    render(conn, :therapy)
  end

  def counseling(conn, _params) do
    render(conn, :counseling)
  end

  def contact(conn, _params) do
    render(conn, :contact)
  end

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
    |> send_resp(200, vcard_data)
  end
end
