# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :teller_sandbox, TellerSandboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MWDDjxQl1L3xk7ki7lbENmNDaJf0DRYZOHtNdjmKqDBfQyn8yYZz0OWf3Pl8qHMk",
  render_errors: [view: TellerSandboxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TellerSandbox.PubSub,
  live_view: [signing_salt: "vhh7O1PD"]

config(:teller_sandbox, date_module: Date, dashboard_module: Teller.Dashboard)

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
