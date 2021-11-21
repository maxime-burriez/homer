defmodule Homer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Homer.Repo,
      # Start the Telemetry supervisor
      HomerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Homer.PubSub},
      # Start the Endpoint (http/https)
      HomerWeb.Endpoint
      # Start a worker by calling: Homer.Worker.start_link(arg)
      # {Homer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Homer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HomerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
