import Config

config :elixir_in_action, todo_list_http_port: 5454

import_config("#{Mix.env()}.exs")
