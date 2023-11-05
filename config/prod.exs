import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :yourhappyfamily, Yourhappyfamily.Endpoint,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :psychemitherz, Psychemitherz.Endpoint,
  url: [host: "psychemitherz.at", port: 4000],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
