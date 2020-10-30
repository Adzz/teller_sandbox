defmodule TellerSandboxWeb.HomeController do
  use TellerSandboxWeb, :controller

  def index(conn, _) do
    send_resp(conn, 200, "Alive!")
  end
end
