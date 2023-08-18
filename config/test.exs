import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :yourhappyfamily, Yourhappyfamily.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "KBtT+LB4mYDNSXuc3mcSyft8R72NQ0Hg4tCKPkH4mxFyUGyopFiodi/v4dsEjMBd",
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :psychemitherz, Psychemitherz.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ALFzg61TdjVDUwREnHGvoV++YU5rXrkAeyOhNEEWjmY+TKHTpHg0gzdRY7knQPF1",
  server: false
