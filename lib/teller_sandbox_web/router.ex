defmodule TellerSandboxWeb.Router do
  use TellerSandboxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TellerSandboxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Teller.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TellerSandboxWeb do
    pipe_through :browser

    get("/", HomeController, :index)
    get("/accounts", AccountController, :all)
    get("/accounts/:account_id", AccountController, :get)
    get("/accounts/:account_id/transactions", TransactionController, :all)
    get("/accounts/:account_id/transactions/:transaction_id", TransactionController, :get)
    live("/dashboard", DashboardLive, :index)
  end
end
