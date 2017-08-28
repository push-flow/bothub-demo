defmodule RalixirWeb.BotManager do
    use GenServer
    def start_link do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_)do
        {:ok, :ets.new(:instantiateds_bots, [:named_table, :set, :public, read_concurrency: true])}
    end

    def register_instantiated_bot {:new_bot, uuid, pid} do
        :ets.insert(:instantiateds_bots, {uuid, pid})  
    end

    def get_instantiated_bot {:check, uuid} do
        case :ets.lookup(:instantiateds_bots, uuid) do
            [{uuid, pid}] ->
                {:ok, %{uuid: uuid, pid: pid}}
            [] ->
                {:error, "bot not instancied"}
        end
    end
end