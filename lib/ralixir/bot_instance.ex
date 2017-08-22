defmodule Ralixir.BotInstance do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ralixir.BotInstance


  schema "bots_instances" do
    field :model_path, :string
    field :name, :string
    field :uuid, Ecto.UUID, autogenerate: true
    field :bot_lang, :string

    timestamps()
  end

  @doc false
  def changeset(%BotInstance{} = bot_instance, attrs) do
    bot_instance
    |> cast(attrs, [:uuid, :name, :bot_manager_id, :model_path])
    |> validate_required([:uuid, :name, :bot_manager_id, :model_path])
  end
end
