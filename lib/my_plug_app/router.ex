defmodule MyPlugApp.Router do
  use Plug.Router

  def child_spec(_) do
    port = String.to_integer(System.get_env("PORT") || "4000")
    Plug.Cowboy.child_spec(scheme: :http, plug: __MODULE__, options: [port: port])
  end

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello from Railway! 🚂")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
