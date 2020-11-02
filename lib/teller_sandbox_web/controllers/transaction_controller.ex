defmodule TellerSandboxWeb.TransactionController do
  use TellerSandboxWeb, :controller
  alias Teller.Contexts.{Account, Transaction}

  def all(conn, %{"account_id" => account_id}) do
    dashboard().increment_endpoint_count(:transactions)

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

  @doc "Gets the specific account if it exists."
  def get(conn, %{"account_id" => account_id, "transaction_id" => transaction_id}) do
    dashboard().increment_endpoint_count(:transaction)

    case Transaction.get_by_id(conn.assigns.token, account_id, transaction_id) do
      nil ->
        put_resp_content_type(conn, "application/json")
        |> Plug.Conn.send_resp(404, "Not Found")

      transaction = %{} ->
        conn |> put_resp_content_type("application/json") |> json(transaction)
    end
  end

  def get(conn, _), do: Plug.Conn.send_resp(conn, 404, "Not Found")

  defp dashboard(), do: Application.fetch_env!(:teller_sandbox, :dashboard_module)
end
