defmodule MyPlugApp.Router do
  use Plug.Router

  def child_spec(_) do
    port = String.to_integer(System.get_env("PORT") || "4000")

    Plug.Cowboy.child_spec(
      scheme: :http,
      plug: __MODULE__,
      options: [port: port]
    )
  end

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], pass: ["*/*"], json_decoder: Jason
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "<h1>🚀 App is running on Railway!</h1><a href='/auth/google'>Login with Google</a>")
  end

  match _ do
    send_resp(conn, 404, "Page Not Found")
  end
end
