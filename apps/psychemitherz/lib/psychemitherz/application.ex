defmodule Psychemitherz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Psychemitherz.Telemetry,
      # Start the Endpoint (http/https)
      Psychemitherz.Endpoint,
      {Phoenix.PubSub, name: Psychemitherz.PubSub}
      # Start a worker by calling: Psychemitherz.Worker.start_link(arg)
      # {Psychemitherz.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Psychemitherz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Psychemitherz.Endpoint.config_change(changed, removed)
    :ok
  end
end
