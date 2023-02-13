defmodule Starwebbie.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    belongs_to :user, Starwebbie.Users.User
    belongs_to :type, Starwebbie.Items.Type
    belongs_to :model, Starwebbie.Items.Model

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :user_id, :model_id, :type_id])
    |> validate_required([:name])
  end
end
