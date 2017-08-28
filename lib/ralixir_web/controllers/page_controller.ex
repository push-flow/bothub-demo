defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  use Export.Python
  import RalixirWeb.BotManager

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
      msg: msg
    }
  end

  defp get_or_start_bot json_map do
    case RalixirWeb.BotManager.get_instantiated_bot({:check, json_map[:uuid]}) do
      {:ok, map} ->
        send_message(json_map)
      {:error, "bot not instancied"} ->
        {:ok, py} = Python.start(python_path: Path.expand("utils"))
        pid = py |> Python.call("elixir_calls", "start_bot", [json_map[:uuid], json_map[:bot_path]])
        RalixirWeb.BotManager.register_instantiated_bot({:new_bot, json_map[:uuid], pid})
        send_message(json_map)
    end
  end
  
  defp send_message json_map do
    c = :gen_tcp.connect({:local, '/tmp/bothub-#{json_map[:uuid]}.sock'}, 0, [])
    :gen_tcp.send(elem(c, 1), Poison.encode! json_map)
  end

  def index(conn, params) do
    json_map = get_json_map(params["uuid"], params["msg"])
    # example url http://localhost:4000/?uuid=b2271dad-51be-4c36-9fbc-9b4f2463859b&msg=i%20want%20food
    get_or_start_bot(json_map)
    
    receive do
      {:tcp, from, msg} ->
        render conn, "index.json", message: msg
    end
  end
end
