defmodule Starwebbie.Repo.Migrations.EnrichItemsAndUser do
  alias Starwebbie.Users
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :credits, :float
    end

    alter table(:items) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :for_sale, :boolean, default: true
    end

    create index(:items, [:user_id])
  end
end
