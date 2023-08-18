# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :yourhappyfamily,
  ecto_repos: [Yourhappyfamily.Repo],
  generators: [context_app: false]

# Configures the endpoint
config :yourhappyfamily, Yourhappyfamily.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: Yourhappyfamily.ErrorHTML, json: Yourhappyfamily.ErrorJSON],
    layout: false
  ],
  pubsub_server: Yourhappyfamily.PubSub,
  live_view: [signing_salt: "l36E62t5"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/yourhappyfamily/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/yourhappyfamily/assets", __DIR__)
  ]

config :psychemitherz,
  ecto_repos: [Psychemitherz.Repo],
  generators: [context_app: false]

# Configures the endpoint
config :psychemitherz, Psychemitherz.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: Psychemitherz.ErrorHTML, json: Psychemitherz.ErrorJSON],
    layout: false
  ],
  pubsub_server: Psychemitherz.PubSub,
  live_view: [signing_salt: "3iz0bBr3"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/psychemitherz/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/psychemitherz/assets", __DIR__)
  ]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
