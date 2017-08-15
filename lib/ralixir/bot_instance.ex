defmodule Ralixir.BotInstance do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ralixir.BotInstance


  schema "bots_instances" do
    belongs_to :bot_manager, Ralixir.BotManager 
    field :model_path, :string
    field :uuid, Ecto.UUID, autogenerate: true

    timestamps()
  end

  @doc false
  def changeset(%BotInstance{} = bot_instance, attrs) do
    bot_instance
    |> cast(attrs, [:uuid, :bot_manager_id, :model_path])
    |> validate_required([:uuid, :bot_manager_id, :model_path])
  end
end
