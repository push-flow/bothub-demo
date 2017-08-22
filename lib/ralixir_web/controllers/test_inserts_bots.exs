alias Ralixir.Repo
alias Ralixir.BotInstance
list_bots_ids = []

bot_instance = %BotInstance{bot_lang: "en_core_web_sm", model_path: Path.expand("utils/models/model_20170811-174056"), name: "Restaurant Bot"} # setting data to create bot instance in especific bot manager server
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name} | list_bots_ids]

bot_instance = %BotInstance{bot_lang: "en_core_web_sm", model_path: Path.expand("utils/models/model_20170816-095626"), name: "Bot Zika En"}
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name} | list_bots_ids]

bot_instance = %BotInstance{bot_lang: "en_core_web_sm", model_path: Path.expand("utils/models/model_20170816-102954"), name: "Bot Zika Fr"}
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name} | list_bots_ids]
