defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  import Ecto.Query
  alias Poison
  alias Ralixir.Repo
  alias Ralixir.BotManager
  alias Ralixir.BotInstance

  defp get_bot_instance(uuid) when is_bitstring(uuid) do 
      from(b in BotInstance, where: b.uuid == ^uuid, preload: [:bot_manager])
      |> Repo.one()    
  end

  defp get_json_map uuid, msg do
    bot = get_bot_instance(uuid)
    %{
      model_path: bot.model_path, 
      uuid: bot.uuid, msg: msg, 
      language: bot.language,
      host: bot.bot_manager.host, 
      port: bot.bot_manager.port
    }
  end
  
  defp send_msg_rasa json_map do
    json_bitstring = Poison.encode!(json_map)
    c = :gen_tcp.connect(String.to_charlist(json_map[:host]), json_map[:port], [])
    :gen_tcp.send(elem(c, 1), json_bitstring)
  end

  def index(conn, params) do
    json_map = get_json_map(params["uuid"], params["msg"])
    # example url http://localhost:4000/?uuid=b2271dad-51be-4c36-9fbc-9b4f2463859b&msg=i%20want%20food
    send_msg_rasa(json_map)
    receive do
      {:tcp, from, msg} ->
        IO.puts msg
        render conn, "index.json", message: msg
    end
  end
end
