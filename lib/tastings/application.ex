defmodule Tastings.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Tastings.Repo,
      # Start the endpoint when the application starts
      TastingsWeb.Endpoint,
      TastingsWeb.Presence
      # Starts a worker by calling: Tastings.Worker.start_link(arg)
      # {Tastings.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tastings.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TastingsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
