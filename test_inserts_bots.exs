alias Ralixir.Repo
alias Ralixir.BotInstance
alias Ralixir.BotManager

bot_mananger = %BotManager{host: "localhost", port: 52011}  # setting data to create a bot mananger server
inserted_bot_mananger = Repo.insert! bot_mananger

bot_instance = %BotInstance{bot_manager: inserted_bot_mananger, model_path: "/Users/victor/projetos/elixir/phoenix/ralixir/utils/models/model_20170811-174056"} # setting data to create bot instance in especific bot manager server
inserted_bot_instance = Repo.insert! bot_instance

bot_instance = %BotInstance{bot_manager: inserted_bot_mananger, model_path: "/Users/victor/projetos/elixir/phoenix/ralixir/utils/models/model_20170811-174056"}
inserted_bot_instance = Repo.insert! bot_instance

bot_instance = %BotInstance{bot_manager: inserted_bot_mananger, model_path: "/Users/victor/projetos/elixir/phoenix/ralixir/utils/models/model_20170811-174056"}
inserted_bot_instance = Repo.insert! bot_instance