defmodule Ralixir.Repo.Migrations.CreateBotsInstances do
  use Ecto.Migration

  def change do
    create table(:bots_instances) do
      add :uuid, :uuid
      add :bot_manager_id, references(:bots_managers)
      add :model_path, :string
      add :language, :string
      add :name, :string

      timestamps()
    end

  end
end
