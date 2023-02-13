defmodule Starwebbie.Items.Model do
  use Ecto.Schema
  import Ecto.Changeset

  schema "models" do
    field :multiplier, :float
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:name, :multiplier])
    |> validate_required([:name, :multiplier])
  end
end
