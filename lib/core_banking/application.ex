defmodule CoreBanking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: CoreBanking.Worker.start_link(arg)
      # {CoreBanking.Worker, arg}
      {
        Plug.Cowboy,
        scheme: :http,
        plug: CoreBanking.Router,
        options: [
          port: http_port()
        ]
      },
      {DynamicSupervisor, strategy: :one_for_one, name: CoreBanking.AccountRegistry}
    ]

    # DynamicSupervisor.start_child(CoreBanking.AccountRegistry, {CoreBanking.Account, :quebuenmeme})

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoreBanking.Supervisor]
    Logger.info("Started Application at http://localhost:#{http_port()}}")
    Supervisor.start_link(children, opts)
  end

  def http_port do
    Application.get_env(:core_banking, :http_port)
  end
end
