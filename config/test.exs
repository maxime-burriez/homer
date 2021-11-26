import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :homer, Homer.Repo,
  username: "postgres",
  password: "postgres",
  database: "homer_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :homer, HomerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "scKgQhrcV35qh2wnKrnqptOUFKL0Lkkr/SnJU7kyvh59yLuv79U0UbUj17jOJz50",
  server: false

# Duffel plug-in
config :homer, duffel_module: Homer.Search.DuffelMock

# In test we don't send emails.
config :homer, Homer.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
