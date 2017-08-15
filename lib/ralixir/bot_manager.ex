defmodule Ralixir.BotManager do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ralixir.BotManager


  schema "bots_managers" do
    field :host, :string
    field :port, :integer
    field :uuid, Ecto.UUID, autogenerate: true
    has_many :bots_instances, Ralixir.BotInstance

    timestamps()
  end

  @doc false
  def changeset(%BotManager{} = bot_manager, attrs) do
    bot_manager
    |> cast(attrs, [:uuid, :host, :port])
    |> validate_required([:uuid, :host, :port])
  end
end
