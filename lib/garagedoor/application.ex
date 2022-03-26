defmodule Garagedoor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      # Garagedoor.Repo,
      # Start the Telemetry supervisor
      GaragedoorWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Garagedoor.PubSub},
      # Start the Endpoint (http/https)
      GaragedoorWeb.Endpoint,
      # Start a worker by calling: Garagedoor.Worker.start_link(arg)
      # {Garagedoor.Worker, arg}

      worker(Cachex, [:door, []], id: :door)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Garagedoor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GaragedoorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
