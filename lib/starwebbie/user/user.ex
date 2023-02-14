defmodule Starwebbie.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string
    field :username, :string
    has_many :items, Starwebbie.Items.Item
    field :credits, :float

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:name, :username, :password, :credits])
    |> unique_constraint(:username)
    |> put_pass_hash()
    |> validate_required([:username, :password])
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password, hash_key: :password))
  end

  defp put_pass_hash(changeset), do: changeset
end
