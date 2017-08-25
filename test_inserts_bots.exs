alias Ralixir.Repo
alias Ralixir.BotInstance
alias Ralixir.BotManager
list_bots_ids = []
bot_mananger = %BotManager{host: "localhost", port: 52020}  # setting data to create a bot mananger server
inserted_bot_mananger = Repo.insert! bot_mananger


bot_instance = %BotInstance{
    bot_path: Path.expand("utils/bots/bot_zika_20170825-095340"), 
    bot_manager: inserted_bot_mananger, 
    name: "Zika Bot"
    } # setting data to create bot instance in especific bot manager server
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name, url: ":4000/?uuid=#{inserted_bot_instance.uuid}&msg=msg here"} | list_bots_ids]


bot_instance = %BotInstance{
    bot_path: Path.expand("utils/bots/bot_restaurant_20170825-100937"), 
    bot_manager: inserted_bot_mananger, 
    name: "Restaurant Bot"
    } # setting data to create bot instance in especific bot manager server
inserted_bot_instance = Repo.insert! bot_instance
list_bots_ids = [ %{bot_id: inserted_bot_instance.uuid, bot_name: inserted_bot_instance.name, url: ":4000/?uuid=#{inserted_bot_instance.uuid}&msg=msg here"} | list_bots_ids]
    
    