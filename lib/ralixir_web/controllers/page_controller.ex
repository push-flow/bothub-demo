defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  use Export.Python

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
      bot_path: bot.bot_path,
      uuid: bot.uuid, 
      msg: msg, 
      host: bot.bot_manager.host, 
      port: bot.bot_manager.port
    }
  end
  
  defp get_or_start_bot json_map do
    {:ok, py} = Python.start(python_path: Path.expand("utils"))
    pid = py |> Python.call("elixir_calls", "start_bot", [json_map[:uuid], json_map[:bot_path]])
  end

  def index(conn, params) do
    json_map = get_json_map(params["uuid"], params["msg"])
    # example url http://localhost:4000/?uuid=b2271dad-51be-4c36-9fbc-9b4f2463859b&msg=i%20want%20food
    IO.puts get_or_start_bot(json_map)
  end
end
