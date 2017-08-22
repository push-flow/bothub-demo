defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  use Export.Python
  import Ecto.Query
  alias Poison
  alias Ralixir.Repo
  alias Ralixir.BotInstance

 

  defp get_bot_instance(uuid) when is_bitstring(uuid) do 
      from(b in BotInstance, where: b.uuid == ^uuid)
      |> Repo.one()    
  end

  def index(conn, params) do
    bot = get_bot_instance(params["uuid"])

    {:ok, py} = Python.start(python_path: Path.expand("utils"))

    r = py |> Python.call("caller_rasa", "interpreter", [bot.bot_lang, params["msg"], bot.model_path])
    IO.puts r

    render conn, "index.json", message: r
    
  end
end
