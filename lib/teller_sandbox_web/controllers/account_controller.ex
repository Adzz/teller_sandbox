defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller

  def all(conn, _) do
    accounts = Teller.Account.from_token(conn.assigns.token)

    conn
    |> put_resp_content_type("application/json")
    |> json(accounts)
  end
end
