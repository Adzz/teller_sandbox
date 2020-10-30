defmodule Teller.AuthenticateTest do
  use TellerSandboxWeb.ConnCase, async: true

  test "a valid token works!", %{conn: conn} do
    connection =
      conn
      |> put_req_header("authorization", "Basic #{Base.url_encode64("test_thing:")}")
      |> Teller.Authenticate.call(%{})

    assert connection.assigns.token == "thing"
  end

  test "an invalid token does not works", %{conn: conn} do
    connection =
      conn
      |> put_req_header("authorization", "Basic #{Base.url_encode64("not a thing:")}")
      |> Teller.Authenticate.call(%{})

    assert connection.resp_body == "Unauthorized"
  end
end
