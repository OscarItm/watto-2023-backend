defmodule Starwebbie.Repo.Migrations.CreateModels do
  use Ecto.Migration

  def change do
    create table(:models) do
      add :name, :string
      add :multiplier, :float

      timestamps()
    end
  end
end
