defmodule MyPlugApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      MyPlugApp.Router
    ]

    opts = [strategy: :one_for_one, name: MyPlugApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
