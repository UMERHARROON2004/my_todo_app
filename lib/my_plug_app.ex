defmodule MyPlugApp do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, 
        scheme: :http, 
        plug: MyPlugApp.Endpoint, 
        options: [port: 4000]
      }
    ]

    opts = [strategy: :one_for_one, name: MyPlugApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule MyPlugApp.Endpoint do
  use Plug.Builder

  plug Plug.Logger
  plug Plug.Session, store: :cookie, key: "_my_plug_app_key", signing_salt: "random_salt"
  plug MyPlugApp.Router
end
