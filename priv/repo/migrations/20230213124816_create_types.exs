defmodule Starwebbie.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :index_price, :integer
      add :name, :string

      timestamps()
    end
  end
end
