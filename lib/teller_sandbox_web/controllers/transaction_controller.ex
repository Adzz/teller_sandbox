defmodule TellerSandboxWeb.TransactionController do
  use TellerSandboxWeb, :controller
  alias Teller.Contexts.{Account, Transaction}

  def all(conn, %{"account_id" => account_id}) do
    with account = %{} <- Account.get_by_id(conn.assigns.token, account_id) do
      transactions = Transaction.generate_from_account(account)

      conn
      |> put_resp_content_type("application/json")
      |> json(transactions)
    else
      nil ->
        put_resp_content_type(conn, "application/json")
        |> Plug.Conn.send_resp(404, "Not Found")
    end
  end

  def all(conn, _), do: Plug.Conn.send_resp(conn, 404, "Not Found")
end
