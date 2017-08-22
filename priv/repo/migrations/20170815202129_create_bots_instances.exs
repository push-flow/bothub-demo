defmodule Ralixir.Repo.Migrations.CreateBotsInstances do
  use Ecto.Migration

  def change do
    create table(:bots_instances) do
      add :uuid, :uuid
      add :model_path, :string
      add :name, :string
      add :bot_lang, :string

      timestamps()
    end

  end
end
