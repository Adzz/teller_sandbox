defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller

  @doc "Returns all accounts for the given token."
  def all(conn, _) do
    accounts = Teller.Account.from_token(conn.assigns.token)

    conn
    |> put_resp_content_type("application/json")
    |> json(accounts)
  end

  @doc "Gets the specific account if it exists."
  def get(conn, %{"account_id" => account_id}) do
    case Teller.Account.from_token(conn.assigns.token) do
      accounts = [_ | _] ->
        account = Enum.find(accounts, &(&1.id == account_id))

        if account do
          conn |> put_resp_content_type("application/json") |> json(account)
        else
          put_resp_content_type(conn, "application/json")
          |> Plug.Conn.send_resp(404, "Not Found")
        end

      account = %{id: id} ->
        if id == account_id do
          conn |> put_resp_content_type("application/json") |> json(account)
        else
          put_resp_content_type(conn, "application/json")
          |> Plug.Conn.send_resp(404, "Not Found")
        end
    end
  end
end
