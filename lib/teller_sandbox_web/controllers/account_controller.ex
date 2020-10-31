defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller

  # Your application may return one or more accounts for a given API token.

  # Given the same API token your server returns the same data each time a request is made,
  # meaning the same account(s) with exactly the same account information, and exactly the
  # same feed of transactions. See below for account names and institutions.

  def get(conn, _) do
    conn.assigns
    |> IO.inspect(limit: :infinity, label: "")
  end
end
