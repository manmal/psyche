defmodule Psychemitherz.GlobalSVG do
  @moduledoc """
  Provides components that occur on (almost) every page.
  """

  use Phoenix.Component
  use Psychemitherz, :verified_routes

  def psychemitherz_logo_full(assigns) do
    ~H"""
    <img
      src={~p"/images/logo_full.svg"}
      width="181"
      height="95"
      alt="Psychemitherz"
      fetchpriority="high"
      decoding="async"
      class="w-[176px] h-[93px] md:w-[240px] md:h-[127px] mx-auto block"
    />
    """
  end
end
