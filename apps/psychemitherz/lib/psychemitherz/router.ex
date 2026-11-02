defmodule Psychemitherz.Router do
  use Psychemitherz, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Psychemitherz.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :public_browser do
    plug :accepts, ["html"]
    plug :put_root_layout, html: {Psychemitherz.Layouts, :root}
    plug :put_secure_browser_headers
    plug :put_public_headers
  end

  pipeline :sitemap do
    plug :accepts, ["xml"]
    plug :put_secure_browser_headers
    plug :put_public_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Psychemitherz do
    pipe_through :public_browser

    get "/", PageController, :home
    get "/uebermich", PageController, :about
    get "/vcard", PageController, :vcard
    get "/therapie", PageController, :therapy
    get "/beratungen", PageController, :counseling
    get "/kontakt", PageController, :contact
  end

  scope "/", Psychemitherz do
    pipe_through :sitemap

    get "/sitemap.xml", SeoController, :sitemap
  end

  # Other scopes may use custom stacks.
  # scope "/api", Psychemitherz do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:psychemitherz, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Psychemitherz.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp put_public_headers(conn, _opts) do
    conn
    |> put_resp_header("content-language", "de-AT")
    |> put_resp_header(
      "cache-control",
      "public, max-age=300, s-maxage=86400, stale-while-revalidate=604800"
    )
  end
end
