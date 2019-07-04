import Config

config :logger, level: :info
config :core_banking, http_port: System.get_env("PORT") || 4000
