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
  attr :level, :integer, default: 2, values: [1, 2, 3]
  slot :inner_block, required: true

  def header_1(assigns) do
    padding_class = if(assigns.top_padding?, do: "pt-10 md:pt-16", else: "")
    center_class = if(assigns.center?, do: "text-center", else: "")
    assigns = assign(assigns, :class, "text-2xl #{padding_class} #{center_class}")

    case assigns.level do
      1 ->
        ~H"""
        <h1 class={@class}><%= render_slot(@inner_block) %></h1>
        """

      2 ->
        ~H"""
        <h2 class={@class}><%= render_slot(@inner_block) %></h2>
        """

      3 ->
        ~H"""
        <h3 class={@class}><%= render_slot(@inner_block) %></h3>
        """
    end
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
        width="375"
        height={if(String.contains?(@path, "wave-2"), do: "194", else: "85")}
        alt=""
        loading="lazy"
        decoding="async"
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
      <picture data-portrait>
        <source
          srcset="/images/bianca-170.webp 170w, /images/bianca-340.webp 340w"
          sizes="170px"
          type="image/webp"
        />
        <img
          src={~p"/images/bianca.jpg"}
          width="510"
          height="581"
          alt="Mag.a Bianca Maly"
          loading="lazy"
          decoding="async"
          class="relative w-[170px] h-[194px] mx-auto z-30 mt-8 rounded-md"
        />
      </picture>
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
  attr :url, :string, default: nil
  attr :overlay?, :boolean, default: false

  def link_arrow(assigns) do
    assigns =
      assigns
      |> assign_new(:url, fn -> nil end)
      |> assign_new(:overlay?, fn -> false end)
      |> assign(
        :bg_color_class,
        if(assigns.overlay?,
          do: "bg-white/60 hover:bg-white",
          else: "bg-green-300 hover:bg-green-100"
        )
      )

    ~H"""
    <%= if @url do %>
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
        rel={if(String.starts_with?(@url, "/"), do: nil, else: "noopener noreferrer")}
      >
        <%= @text %> →
      </a>
    <% else %>
      <span class={"inline-flex gap-1 px-2.5 py-1 font-sans no-underline
        rounded-md text-red-700 font-medium #{@bg_color_class} "}>
        <%= @text %> →
      </span>
    <% end %>
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
      <img
        src={~p"/images/email_icon.svg"}
        width="20"
        height="16"
        alt=""
        aria-hidden="true"
        class="w-4"
      />
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
      Kontakt auf Ihrem Handy speichern
      <img
        src={~p"/images/download.svg"}
        width="22"
        height="22"
        alt=""
        aria-hidden="true"
        class="w-4"
      />
    </a>
    """
  end

  def link_insta(assigns) do
    ~H"""
    <a
      href="https://www.instagram.com/psychemitherz/"
      target="_blank"
      rel="noopener noreferrer"
      aria-label="Instagram"
      class="inline-flex gap-2 px-2.5 py-1 font-sans h-10 w-10 items-center justify-center
      rounded-md text-yellow-900 font-medium bg-gradient-to-br from-pink-400 to-yellow-300 hover:from-pink-300"
    >
      <img
        src={~p"/images/instagram_logo.svg"}
        width="25"
        height="25"
        alt=""
        aria-hidden="true"
        class="w-6"
      />
    </a>
    """
  end

  def link_facebook(assigns) do
    ~H"""
    <a
      href="https://www.facebook.com/profile.php?id=100077709940441"
      target="_blank"
      rel="noopener noreferrer"
      aria-label="Facebook"
      class="inline-flex gap-2 px-2.5 py-1 font-sans h-10 w-10 items-center justify-center
      rounded-md text-white font-medium bg-gradient-to-br from-blue-600 to-blue-400 hover:from-blue-500 hover:to-blue-300"
    >
      <img
        src={~p"/images/facebook_logo.svg"}
        width="22"
        height="22"
        alt=""
        aria-hidden="true"
        class="w-6"
      />
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
      <img
        src={~p"/images/phone_icon.svg"}
        width="20"
        height="21"
        alt=""
        aria-hidden="true"
        class="w-4"
      />
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

  attr :bg_image, :string, required: true
  attr :bg_image_webp, :string, required: true
  attr :width, :integer, required: true
  attr :height, :integer, required: true

  defp therapy_box_image(assigns) do
    ~H"""
    <picture data-therapy-card class="pointer-events-none absolute inset-0" aria-hidden="true">
      <source srcset={@bg_image_webp} type="image/webp" width={@width} height={@height} />
      <img
        src={@bg_image}
        width={@width}
        height={@height}
        alt=""
        aria-hidden="true"
        class="absolute inset-0 h-full w-full object-contain object-right-top mix-blend-multiply"
      />
    </picture>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :url, :string, default: nil
  attr :link_text, :string, required: true

  defp therapy_box_content(assigns) do
    ~H"""
    <h2 class="relative z-10"><%= @title %></h2>
    <div :if={@subtitle} class="relative z-10 text-[0.93rem] -mt-1 grow"><%= @subtitle %></div>
    <span
      :if={@url}
      class="relative z-10 inline-flex gap-1 px-2.5 py-1 font-sans no-underline
      rounded-md text-red-700 font-medium bg-white/60 hover:bg-white"
    >
      <%= @link_text %> →
    </span>
    <div :if={@url} class="relative z-10 grow" />
    """
  end

  attr :title, :string, default: "Undefined title"
  attr :subtitle, :string, required: false
  attr :bg_color, :string, required: true
  attr :bg_image, :string, required: true
  attr :bg_image_webp, :string, required: true
  attr :bg_image_width, :integer, required: true
  attr :bg_image_height, :integer, required: true
  attr :url, :string, required: false

  def therapy_box(assigns) do
    assigns =
      assigns
      |> assign_new(:subtitle, fn -> nil end)
      |> assign_new(:url, fn -> nil end)

    cursor_class = if(assigns[:url], do: "cursor-pointer no-underline", else: "")

    link_text =
      if(assigns[:url] && String.starts_with?(assigns.url, "/"),
        do: "Mehr erfahren",
        else: if(assigns[:url], do: remove_schema_and_subdomains(assigns.url), else: "")
      )

    assigns =
      assigns
      |> assign(
        :wrapper_class,
        "relative flex flex-col w-full items-start justify-center gap-2 px-3 py-2 md:px-6 md:py-4
        min-h-[6rem] rounded-md #{assigns.bg_color} scroll-mt-16 #{cursor_class}"
      )
      |> assign(:link_text, link_text)

    ~H"""
    <%= if @url do %>
      <a href={@url} class={@wrapper_class} id={to_slug(@title)}>
        <.therapy_box_image
          bg_image={@bg_image}
          bg_image_webp={@bg_image_webp}
          width={@bg_image_width}
          height={@bg_image_height}
        />
        <.therapy_box_content title={@title} subtitle={@subtitle} url={@url} link_text={@link_text} />
      </a>
    <% else %>
      <div class={@wrapper_class} id={to_slug(@title)}>
        <.therapy_box_image
          bg_image={@bg_image}
          bg_image_webp={@bg_image_webp}
          width={@bg_image_width}
          height={@bg_image_height}
        />
        <.therapy_box_content title={@title} subtitle={@subtitle} url={@url} link_text={@link_text} />
      </div>
    <% end %>
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
