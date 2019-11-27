defmodule Pets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      PetsWeb.Endpoint,
      # Starts a worker by calling: Pets.Worker.start_link(arg)
      # {Pets.Worker, arg},
      worker(Mongo, [[database: Application.get_env(:pets, :db)[:name], name: :mongo]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pets.Supervisor]
    result = Supervisor.start_link(children, opts)
    Pets.Startup.ensure_indexes()
    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PetsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
