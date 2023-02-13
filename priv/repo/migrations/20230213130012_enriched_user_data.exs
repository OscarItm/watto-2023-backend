defmodule Starwebbie.Repo.Migrations.EnrichedUserData do
  alias Starwebbie.Users
  use Ecto.Migration

  def change do
    alter table :users do
      add :credits, :float

    end
    alter table :items do
      add :user_id, references(:users, on_delete: :delete_all)

    end

    create index(:items, [:user_id])
  end
end
