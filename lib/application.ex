defmodule Debt.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Debt.Scheduler
    ]

    opts = [strategy: :one_for_one, name: Debt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
