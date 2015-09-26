use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :beermusings, Beermusings.Endpoint,
  secret_key_base: "V6A3H5K1tgZPAlB8HpQJn3L1l240QKyHe6ud3Y1q6kqoK3DYGgCaXs77yju47wHp"

# Configure your database
config :beermusings, Beermusings.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "beermusings_prod",
  pool_size: 20
