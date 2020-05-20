defmodule Debt.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :logger.remove_handler(:default)
    :logger.remove_handler(Logger)
    :logger.add_handlers(:debt)

    _ = Application.fetch_env!(:debt, :secret)

    children = [
      Debt.Scheduler,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Debt.Router,
        options: [port: 8080]
      )
    ]

    opts = [strategy: :one_for_one, name: Debt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
