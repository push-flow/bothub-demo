defmodule Ralixir.Repo.Migrations.CreateBotsManagers do
  use Ecto.Migration

  def change do
    create table(:bots_managers) do
      add :uuid, :uuid
      add :host, :string
      add :port, :integer

      timestamps()
    end

  end
end
