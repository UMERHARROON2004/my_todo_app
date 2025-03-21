defmodule MyPlugApp.Router do
  use Plug.Router

  # Dynamic port fetch from ENV for deployment (Fly.io compatibility)
  def child_spec(_) do
    port = String.to_integer(System.get_env("PORT") || "4000")
    Plug.Cowboy.child_spec(scheme: :http, plug: __MODULE__, options: [port: port])
  end

  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], pass: ["*/*"], json_decoder: Jason
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, """
    <html>
      <head>
        <title>MyPlugApp - Login</title>
        <style>
          body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
          .container { width: 300px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; box-shadow: 2px 2px 10px rgba(0,0,0,0.1); }
          .btn { display: inline-block; padding: 10px 20px; margin: 10px; color: white; background: #4285F4; text-decoration: none; border-radius: 5px; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Welcome to MyPlugApp</h1>
          <p>Login to continue</p>
          <a class="btn" href="/auth/google">Login with Google</a>
        </div>
      </body>
    </html>
    """)
  end

  get "/auth/google/callback" do
    user_info = get_google_user_info(conn)

    conn
    |> put_session(:user, user_info)
    |> redirect("/dashboard")
  end

  get "/dashboard" do
    user = get_session(conn, :user)

    if user do
      send_resp(conn, 200, """
      <html>
        <head>
          <title>Dashboard</title>
          <style>
            body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
            .container { width: 300px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; box-shadow: 2px 2px 10px rgba(0,0,0,0.1); }
            .btn { display: inline-block; padding: 10px 20px; margin: 10px; color: white; background: red; text-decoration: none; border-radius: 5px; }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>Welcome, #{user["name"]}</h1>
            <p>Email: #{user["email"]}</p>
            <img src="#{user["picture"]}" width="100">
            <br>
            <a class="btn" href="/logout">Logout</a>
          </div>
        </body>
      </html>
      """)
    else
      redirect(conn, "/")
    end
  end

  get "/logout" do
    conn
    |> configure_session(drop: true)
    |> redirect("/")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp get_google_user_info(conn) do
    %{"email" => "test@example.com", "name" => "Test User", "picture" => "https://via.placeholder.com/100"}
    # This should be replaced with actual Google OAuth user info fetching logic.
  end

  defp redirect(conn, path) do
    conn
    |> put_resp_header("location", path)
    |> send_resp(302, "")
  end
end
