defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller
  alias Teller.Contexts.Account

  @doc "Returns all accounts for the given token."
  def all(conn, _) do
    dashboard().increment_endpoint_count(:accounts)

    accounts = Account.from_token(conn.assigns.token)

    conn
    |> put_resp_content_type("application/json")
    |> json(accounts)
  end

  @doc "Gets the specific account if it exists."
  def get(conn, %{"account_id" => account_id}) do
    dashboard().increment_endpoint_count(:account)

    case Account.get_by_id(conn.assigns.token, account_id) do
      nil ->
        put_resp_content_type(conn, "application/json")
        |> Plug.Conn.send_resp(404, "Not Found")

      account = %{} ->
        conn |> put_resp_content_type("application/json") |> json(account)
    end
  end

  defp dashboard(), do: Application.fetch_env!(:teller_sandbox, :dashboard_module)
end
