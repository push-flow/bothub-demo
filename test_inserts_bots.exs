alias Ralixir.Repo
alias Ralixir.BotInstance
list_bots_ids = []
bot_mananger = %BotManager{host: "localhost", port: 52020}  # setting data to create a bot mananger server
inserted_bot_mananger = Repo.insert! bot_mananger

bot_instance = %BotInstance{bot_mananger_id: inserted_bot_mananger, language: "en_core_web_sm", model_path: Path.expand("utils/models/model_20170822-135323"), name: "Restaurant Bot"} # setting data to create bot instance in especific bot manager server
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name} | list_bots_ids]

bot_instance = %BotInstance{bot_mananger_id: inserted_bot_mananger,language: "en_core_web_sm", model_path: Path.expand("utils/models/model_20170822-135323"), name: "Bot Zika En"}
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name} | list_bots_ids]

bot_instance = %BotInstance{bot_mananger_id: inserted_bot_mananger,language: "en_core_web_sm", model_path: Path.expand("utils/models/model_20170822-135323"), name: "Bot Zika Fr"}
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name} | list_bots_ids]
