import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :yourhappyfamily, Yourhappyfamily.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "7SXdG2rXDKBQQm5VqSpcuP2ZPKKiFa0NX4YFKy7cXVpA6BCAhgw1Qm8O1HyRzQ4E",
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :psychemitherz, Psychemitherz.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QqCfWo1z3a6i/oOIWum4dZLxExCYGo3IFTLcI9TjpbijrlbLdW3aCabU07voEJaq",
  server: false
