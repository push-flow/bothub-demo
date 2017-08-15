defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  use Export.Python
  alias Poison
  # def send_msg_rasa do
  #   1+2
  #   receive do
  #     _ -> 1+2
  #   end
  # end

  def index(conn, _params) do
    json_map = Poison.decode!(~s({"model_path":"/Users/victor/projetos/elixir/phoenix/ralixir/utils/models/model_20170811-174056", "msg": "i want food" }))
    json_bitstring = Poison.encode!(json_map)
    c = :gen_tcp.connect('localhost', 52009, [])
    :gen_tcp.send(elem(c, 1), json_bitstring)
    # p = spawn(send_msg_rasa)
    # send p, {self, "i want eat my brothers"}
    receive do
       {:tcp ,from, msg} ->
        IO.puts msg
        render conn, "index.html"
     end
  end
end
