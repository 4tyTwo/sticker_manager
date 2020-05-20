defmodule Debt.Authentication do
  import Plug.Conn

  def init(opts), do: opts

  def authenticated?(conn) do
    case Plug.Conn.get_req_header(conn, "secret") do
      [] -> false
      [value] -> is_secret_correct?(value)
      _ -> false
    end
  end

  def call(conn, _opts) do
    if authenticated?(conn) do
      conn
    else
      conn
      |> send_resp(401, "")
      |> halt
    end
  end

  defp is_secret_correct?(value) do
    value === Application.fetch_env!(:debt, :secret)
  end
end
