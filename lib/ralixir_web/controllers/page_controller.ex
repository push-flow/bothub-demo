defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  alias Poison
  def send_msg_rasa json_map do
    json_bitstring = Poison.encode!(json_map)
    c = :gen_tcp.connect('localhost', 52011, [])
    :gen_tcp.send(elem(c, 1), json_bitstring)
  end

  def index(conn, _params) do
    json_map = Poison.decode!(~s({"model_path":"/Users/victor/projetos/elixir/phoenix/ralixir/utils/models/model_20170811-174056", "msg": "i want food" }))
 
    send_msg_rasa(json_map)
    receive do
       {:tcp ,from, msg} ->
        IO.puts msg
        render conn, "index.html"
     end
  end
end
