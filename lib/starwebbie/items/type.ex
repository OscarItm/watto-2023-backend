defmodule Starwebbie.Items.Type do
  use Ecto.Schema
  import Ecto.Changeset

  schema "types" do
    field :index_price, :integer
    field :name, :string
    has_many :items, Starwebbie.Items.Item

    timestamps()
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:index_price, :name])
    |> validate_required([:index_price, :name])
  end
end
