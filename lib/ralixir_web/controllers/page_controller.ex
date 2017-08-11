defmodule RalixirWeb.PageController do
  use RalixirWeb, :controller
  use Export.Python

  def index(conn, _params) do
    {:ok, py} = Python.start(python_path: Path.expand("utils"))
    path_models = Path.expand("utils/models/model_20170810-214535")
    a = py |> Python.call(get_rasa_response(path_models, "i want eat my brothers"), from_file: "caller_rasa")
    IO.puts a
    render conn, "index.html"
  end
end
