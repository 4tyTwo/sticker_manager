defmodule Debt.Router do
  use Plug.Router
  plug Debt.Authentication
  plug :match
  plug :dispatch

  post "/update" do
    {status, body} = case Debt.Updater.update_sticker do
      :ok -> {200, "Executed update_sticker"}
      {:error, _} = error -> {500, "An error occured, #{inspect(error)}"}
    end
    Plug.Conn.send_resp conn, status, body
  end

  get "/health" do
    Plug.Conn.send_resp conn, 200, "running"
  end

end
