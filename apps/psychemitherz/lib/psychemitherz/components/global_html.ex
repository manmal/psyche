defmodule Psychemitherz.GlobalHtml do
  @moduledoc """
  Provides components that occur on (almost) every
  page.
  """

  use Phoenix.Component
  use Psychemitherz, :verified_routes
  import Psychemitherz.ContactData
  import Slugify
  import UrlUtils

  slot :inner_block, required: true

  def main_content(assigns) do
    ~H"""
    <div class="px-4 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-3xl">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr :top_padding?, :boolean, default: true
  attr :center?, :boolean, default: false
  slot :inner_block, required: true

  def header_1(assigns) do
    ~H"""
    <h1 class={"text-2xl
        #{if(assigns.top_padding?, do: "pt-10 md:pt-16", else: "")}
        #{if(assigns.center?, do: "text-center", else: "")}
        "}>
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end

  slot :inner_block, required: true

  def list_with_dots(assigns) do
    ~H"""
    <ul class="list-disc ml-4">
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  attr :path, :string, required: true
  attr :css_class, :string, required: false

  def deco(assigns) do
    ~H"""
    <div class="relative">
      <img
        src={@path}
        class={"w-full absolute opacity-70 -z-10 #{if(assigns[:css_class] != nil, do: @css_class, else: "")}"}
      />
    </div>
    """
  end

  def full_name(assigns) do
    ~H"""
    Mag.<sup>a</sup> Bianca Maly
    """
  end

  def portrait_pic_with_deco(assigns) do
    ~H"""
    <div class="relative shrink-0">
      <div class="absolute left-1/2 bg-green-300 w-32 h-44 rounded-md -mx-32"></div>
      <img
        src={~p"/images/bianca.jpg"}
        class="relative w-[170px] h-[194px] mx-auto z-30 mt-8 rounded-md"
      />
    </div>
    """
  end

  attr :large?, :boolean, default: false

  def name_and_email(assigns) do
    assigns =
      assigns
      |> assign(
        :name_font_size_class,
        if(assigns.large?, do: "text-lg/8", else: "text-[0.96rem]/4 lg:text-[1rem]/5")
      )
      |> assign(
        :email_font_size_class,
        if(assigns.large?, do: "text-base/5", else: "text-[0.85rem]/5")
      )

    ~H"""
    <div class="flex flex-col p-2">
      <span class={"font-serif #{@name_font_size_class}"}>
        <.full_name />
      </span>
      <a
        href="mailto:&#112;&#114;&#097;&#120;&#105;&#115;&#064;&#112;&#115;&#121;&#099;&#104;&#101;&#109;&#105;&#116;&#104;&#101;&#114;&#122;&#046;&#097;&#116;"
        class={"text-sm leading-5 underline #{@email_font_size_class}"}
      >
        &#112;&#114;&#097;&#120;&#105;&#115;&#064;&#112;&#115;&#121;&#099;&#104;&#101;&#109;&#105;&#116;&#104;&#101;&#114;&#122;&#046;&#097;&#116;
      </a>
    </div>
    """
  end

  attr :text, :string, default: "Mehr erfahren"
  attr :url, :string, default: "#"
  attr :overlay?, :boolean, default: false

  def link_arrow(assigns) do
    assigns =
      assigns
      |> assign(
        :bg_color_class,
        if(assigns.overlay?,
          do: "bg-white/60 hover:bg-white",
          else: "bg-green-300 hover:bg-green-100"
        )
      )

    ~H"""
    <a
      href={@url}
      class={"inline-flex gap-1 px-2.5 py-1 font-sans no-underline
      rounded-md text-red-700 font-medium #{@bg_color_class}"}
      target={
        if(String.starts_with?(@url, "/") || String.starts_with?(@url, "#"),
          do: "_self",
          else: "_blank"
        )
      }
    >
      <%= @text %> →
    </a>
    """
  end

  attr :email, :string, required: true

  def link_email(assigns) do
    ~H"""
    <a
      href={"mailto:#{@email}"}
      class="inline-flex gap-2 px-2.5 py-1 font-sans
      rounded-md text-red-700 font-medium bg-pink-base hover:bg-pink-light"
    >
      <%= @email %>
      <img src={~p"/images/email_icon.svg"} class="w-4" />
    </a>
    """
  end

  attr :email, :string, required: true

  def link_yourhappyfamily(assigns) do
    ~H"""
    <a
      href="https://www.yourhappyfamily.at"
      style={"--image-url: url(#{~p"/images/your_happy_family.png"})"}
      class="inline-flex gap-2 px-2.5 py-1 font-sans
      rounded-md text-red-700 font-medium bg-pink-base hover:bg-pink-light
      bg-[image:var(--image-url)] bg-contain bg-[position:top_right] bg-blend-multiply
      bg-no-repeat"
    >
      yourhappyfamily.at →
    </a>
    """
  end

  def link_vcard(assigns) do
    ~H"""
    <a
      href={~p"/vcard"}
      class="inline-flex gap-2 px-2.5 py-1 font-sans
      rounded-md text-red-700 font-medium bg-yellow-500 hover:bg-yellow-300"
    >
      Kontakt auf Ihrem Handy speichern <img src={~p"/images/download.svg"} class="w-4" />
    </a>
    """
  end

  def link_insta(assigns) do
    ~H"""
    <a
      href="https://www.instagram.com/psychemitherz/"
      target="_blank"
      class="inline-flex gap-2 px-2.5 py-1 font-sans h-10 w-10 items-center justify-center
      rounded-md text-yellow-900 font-medium bg-gradient-to-br from-pink-400 to-yellow-300 hover:from-pink-300"
    >
      <img src={~p"/images/instagram_logo.svg"} class="w-6" />
    </a>
    """
  end

  def link_facebook(assigns) do
    ~H"""
    <a
      href="https://www.facebook.com/profile.php?id=100077709940441"
      target="_blank"
      class="inline-flex gap-2 px-2.5 py-1 font-sans h-10 w-10 items-center justify-center
      rounded-md text-white font-medium bg-gradient-to-br from-blue-600 to-blue-400 hover:from-blue-500 hover:to-blue-300"
    >
      <img src={~p"/images/facebook_logo.svg"} class="w-6" />
    </a>
    """
  end

  def link_phone(assigns) do
    ~H"""
    <a
      href={"tel:#{String.replace(phone(), " ", "")}"}
      class="inline-flex gap-2 px-2.5 py-1 font-sans
      rounded-md text-red-700 font-medium bg-pink-base hover:bg-pink-light"
    >
      <%= phone() %>
      <img src={~p"/images/phone_icon.svg"} class="w-4" />
    </a>
    """
  end

  attr :text, :string, default: "Termin buchen"
  attr :url, :string, required: false

  def book_button(assigns) do
    ~H"""
    <div class="relative inline-block">
      <a
        href={if(assigns[:url] != nil, do: @url, else: ~p"/kontakt")}
        class="relative inline-block gap-1 px-4 text-base md:px-8 py-2 font-sans no-underline
         text-red-700 font-medium rounded-sm bg-yellow-300
         hover:bg-yellow-200 border-[3px] border-yellow-500"
      >
        <%= @text %>
      </a>
      <div class="absolute -bottom-2 -left-2 w-full h-full rounded-sm bg-yellow-500 -z-10" />
    </div>
    """
  end

  attr :title, :string, default: "Undefined title"
  attr :subtitle, :string, required: false
  attr :bg_color, :string, required: true
  attr :bg_image, :string, required: true
  attr :url, :string, required: false

  def therapy_box(assigns) do
    ~H"""
    <div
      style={"--image-url: url(#{@bg_image})"}
      class={"flex flex-col w-full items-start justify-center gap-2 px-3 py-2 md:px-6 md:py-4
            min-h-[6rem] rounded-md #{@bg_color} bg-[image:var(--image-url)]
            bg-contain bg-[position:top_right] bg-blend-multiply bg-no-repeat scroll-mt-16
            #{if(assigns[:url] != nil, do: "cursor-pointer", else: "")}"}
      id={to_slug(@title)}
      onclick={if(assigns[:url] != nil, do: "window.open('#{@url}', )", else: "")}
    >
      <h2><%= @title %></h2>
      <div :if={assigns[:subtitle] != nil} class="text-[0.93rem] -mt-1 grow">
        <%= @subtitle %>
      </div>
      <.link_arrow
        :if={assigns[:url] != nil}
        url={@url}
        overlay?={true}
        text={
          if(String.starts_with?(@url, "/"),
            do: "Mehr erfahren",
            else: remove_schema_and_subdomains(@url)
          )
        }
      />
      <div :if={assigns[:url] != nil} class="grow" />
    </div>
    """
  end

  attr :full?, :boolean, required: true

  def contact_details(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 mt-2 items-start">
      <div>
        <span class="text-[1.1rem] font-semibold"><.full_name /></span>
        <br /> <%= practice() %> <br /> <%= street_and_number() %> <br />
        <%= postal_code() %> <%= city() %><br />
        <a href={website()} class="underline">
          <%= website() %>
        </a>
      </div>
      <.link_email email={email()} />
      <.link_phone />
      <.link_vcard />
      <div :if={@full?} class="flex flex-row gap-4">
        <.link_insta />
        <.link_facebook />
      </div>
      <.link_arrow :if={!@full?} text="Alle Kontaktmöglichkeiten" url={~p"/kontakt"} />
    </div>
    """
  end
end
