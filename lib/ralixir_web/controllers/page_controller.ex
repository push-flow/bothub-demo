defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  use Export.Python
  def start_interpreter do
    {:ok, py} = Python.start(python_path: Path.expand("utils"))
    path_models = Path.expand("utils/models/model_20170811-174056")
    py |> Python.call("caller_rasa", "start_interpreter", [path_models])
    # IO.puts j
    r = py |> Python.call("caller_rasa", "interpretator", ["i want food"])
    IO.puts r

    receive do
      {from, msg} ->
        #r = py |> Python.call(interpretator(msg,k ), from_file: "caller_rasa")
        send from, {self, r}
    end
  end

  def index(conn, _params) do
    p = spawn(start_interpreter)
    send p, {self, "i want eat my brothers"}
    
    receive do
      {from, msg} ->
        IO.puts msg
        render conn, "index.html"
    end
  end
end
