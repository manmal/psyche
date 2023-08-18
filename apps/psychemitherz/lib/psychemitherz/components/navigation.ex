defmodule Psychemitherz.MenuItemType do
  alias Psychemitherz.{MenuItemLeaf, MenuItemContainer}
  @type menu_item :: MenuItemLeaf.t() | MenuItemContainer.t()
end

defmodule Psychemitherz.MenuItemLeaf do
  alias Psychemitherz.MenuItemLeaf
  @enforce_keys [:title, :url]
  defstruct [:title, :url]

  @type t :: %MenuItemLeaf{
          title: String.t(),
          url: String.t()
        }
end

defmodule Psychemitherz.MenuItemContainer do
  alias Psychemitherz.MenuItemContainer
  @enforce_keys [:title, :sub_items, :title_css_class, :bg_css_class]
  defstruct [:title, :sub_items, :title_css_class, :bg_css_class]

  @type t :: %MenuItemContainer{
          title: String.t(),
          sub_items: [MenuItemLeaf.t()],
          title_css_class: String.t(),
          bg_css_class: String.t()
        }
end

defmodule Psychemitherz.NavigationHtml do
  use Phoenix.Component
  use Psychemitherz, :verified_routes
  import Psychemitherz.GlobalHtml
  alias Psychemitherz.{MenuItemLeaf, MenuItemContainer}

  attr :menu_items, :list, required: true
  attr :request_path, :string, required: true

  def navigation(assigns) do
    ~H"""
    <nav class="relative max-h-screen flex flex-col">
      <div class="w-full sm:max-w-3xl mx-auto pl-4 sm:pl-0">
        <div class="flex justify-between">
          <div class="flex space-x-2 lg:space-x-4" id="header-info-container">
            <div
              class={"flex items-center gap-1 #{if(@request_path == "/", do: "opacity-0", else: "")}"}
              id="header-info"
            >
              <a href={~p"/"}>
                <img src={~p"/images/logo_compact.svg"} class="w-9 lg:w-10" />
              </a>
              <.name_and_email />
            </div>
            <.menu_md items={@menu_items} />
          </div>
          <.menu_button_mobile close?={false} />
        </div>
      </div>
      <.menu_mobile items={@menu_items} />
    </nav>
    """
  end

  attr :items, :list, required: true

  defp menu_mobile(%{items: [_ | _]} = assigns) do
    ~H"""
    <div class="hidden mobile-menu bg-creme fixed top-0 left-0 right-0 bottom-0 z-50 h-screen">
      <div class="fixed right-0 top-2.5"><.menu_button_mobile close?={true} /></div>
      <ul class="overflow-y-scroll h-full py-8">
        <%= for item <- @items do %>
          <.menu_item_mobile item={item} />
        <% end %>
      </ul>
    </div>
    <script>
      const header = document.getElementById("header");
      const openButton = document.querySelector("button.mobile-menu-button-open");
      const closeButton = document.querySelector("button.mobile-menu-button-close");
      const menu = document.querySelector(".mobile-menu");
      const menuIconPath = document.getElementById('menu-icon-path');
      openButton.addEventListener("click", () => {
        const isExpanded = header.style.height === "100vh";
        header.style.height = "100vh";
        menu.classList.remove('hidden');
        header.classList.add('!bg-creme');
        menuIconPath.setAttribute('d', "M4 4L20 20M4 20L20 4");
      });
      closeButton.addEventListener("click", () => {
        const isExpanded = header.style.height === "100vh";
        header.style.height = "auto";
        menu.classList.add('hidden');
        header.classList.remove('!bg-creme');
        menuIconPath.setAttribute('d', "M2 6h20M2 12h20M2 18h20");
      });
    </script>
    """
  end

  attr :close?, :boolean, required: true

  defp menu_button_mobile(assigns) do
    ~H"""
    <div class="md:hidden flex items-stretch">
      <button class={"outline-none mobile-menu-button-#{if(@close?, do: "close", else: "open")} px-4"}>
        <svg
          class="w-8 h-8 text-red-700"
          x-show="!showMenu"
          fill="none"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="1.5"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            id="menu-icon-path"
            d={if(@close?, do: "M4 4L20 20M4 20L20 4", else: "M2 6h20M2 12h20M2 18h20")}
          >
          </path>
        </svg>
      </button>
    </div>
    """
  end

  defp menu_item_mobile(%{item: %MenuItemLeaf{}} = assigns) do
    ~H"""
    <li class="active mt-1">
      <a href={@item.url} class="block text-lg px-8 py-2 font-semibold">
        <%= @item.title %>
      </a>
    </li>
    """
  end

  defp menu_item_mobile(%{item: %MenuItemContainer{}} = assigns) do
    ~H"""
    <li class={"active mt-4 m-4 py-2 rounded-md
    #{if(@item.bg_css_class == "bg-yellow-200", do: "bg-yellow-200/50", else: "bg-green-200/50")}"}>
      <ul>
        <div class={"text-sm mx-4 uppercase tracking-widest #{@item.title_css_class}"}>
          <%= @item.title %>
        </div>
        <%= for sub_item <- @item.sub_items do %>
          <li>
            <a href={sub_item.url} class="block text-lg px-4 py-2 font-semibold">
              <%= sub_item.title %>
            </a>
          </li>
        <% end %>
      </ul>
    </li>
    """
  end

  attr :items, :list, required: true

  defp menu_md(%{items: [_ | _]} = assigns) do
    ~H"""
    <div class="hidden md:flex md:items-start items-center text-[0.95rem]">
      <%= for item <- @items do %>
        <.menu_item_md item={item} />
      <% end %>
    </div>
    """
  end

  defp menu_item_md(%{item: %MenuItemLeaf{}} = assigns) do
    ~H"<.menu_item_md_link title={@item.title} url={@item.url} />"
  end

  alias Psychemitherz.MenuItemContainer

  defp menu_item_md(%{item: %MenuItemContainer{}} = assigns) do
    ~H"""
    <div class="inline-block relative hover-menu-item">
      <.menu_item_md_link title={@item.title} />
      <div class="hidden -mx-4 -mt-2 px-4 pb-4 peer-hover:absolute peer-hover:flex hover:absolute hover:flex
                 flex-col">
        <div class={"flex flex-col rounded-md #{@item.bg_css_class} overflow-hidden whitespace-nowrap text-[0.8rem] lg:text-[1rem]"}>
          <%= for sub_item <- @item.sub_items do %>
            <a class="px-5 py-3 hover:bg-white/30" href={sub_item.url}><%= sub_item.title %></a>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :url, :string, required: false

  defp menu_item_md_link(assigns) do
    assigns =
      assign(assigns, :shared_css, "peer inline-block relative py-4 px-2.5 whitespace-nowrap
    text-[0.8rem] lg:text-[1rem] text-red-800 font-serif")

    case assigns[:url] do
      nil ->
        ~H"""
        <div class={"#{@shared_css} hover:cursor-default"}><%= @title %></div>
        """

      _ ->
        ~H"""
        <a href={@url} class={"#{@shared_css} hover:text-green-500 transition duration-300"}>
          <%= @title %>
        </a>
        """
    end
  end
end
