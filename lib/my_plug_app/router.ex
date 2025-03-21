defmodule MyPlugApp.Router do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], pass: ["*/*"], json_decoder: Jason
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello from Railway! Your Plug app is working.")
  end

  match _ do
    send_resp(conn, 404, "Page not found!")
  end
end
