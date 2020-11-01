use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :teller_sandbox, TellerSandboxWeb.Endpoint,
  http: [port: 4002],
  server: false

config(:teller_sandbox, date_module: DateMock)

# Print only warnings and errors during test
config :logger, level: :warn
