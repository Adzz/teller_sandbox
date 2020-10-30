defmodule Teller.Authenticate do
  @moduledoc """
  A thin wrapper around the basic auth plug, we ignore the password and validate the user token
  which should be contained in the username field.
  """
  import Plug.Conn

  def init(options), do: options

  @doc """
  Validates that the token is one that we recognize. I'm not clear whether we force it to be an
  actual token or what. The token will become the seed for random data generation so we may
  want to enforce it has sufficient entropy / length or whatever.
  """
  def call(conn, _opts) do
    with {"test_" <> user_name_token, _} <- Plug.BasicAuth.parse_basic_auth(conn),
         {:ok, _validate} <- validate_token(user_name_token) do
      assign(conn, :token, user_name_token)
    else
      _ -> Plug.BasicAuth.request_basic_auth(conn) |> halt()
    end
  end

  # We can do as much or as little validation here. I wasn't quite sure what the format of the token
  # should be. IF it is submitted via CURL or whatever it gets encoded for us.
  defp validate_token(_token) do
    {:ok, true}
  end
end
