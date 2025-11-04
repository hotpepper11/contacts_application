defmodule ContactsApplication.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ContactsApplicationWeb.Telemetry,
      ContactsApplication.Repo,
      {DNSCluster, query: Application.get_env(:contacts_application, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ContactsApplication.PubSub},
      # Start a worker by calling: ContactsApplication.Worker.start_link(arg)
      # {ContactsApplication.Worker, arg},
      # Start to serve requests, typically the last entry
      ContactsApplicationWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ContactsApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ContactsApplicationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
