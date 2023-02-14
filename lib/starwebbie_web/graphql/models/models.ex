defmodule StarwebbieWeb.Models do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :username, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :user_auth do
    field :token, :string
    field :user, :user
  end

  object :type do
    field :id, non_null(:id)
    field :name, :string
    field :index_price, :integer
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :model do
    field :id, non_null(:id)
    field :name, :string
    field :multiplier, :float
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :item do
    field :id, non_null(:id)
    field :name, :string
    field :model, non_null(:model)
    field :type, non_null(:type)

    field :price, :float do
      resolve(fn parent, _args, _context ->
        {:ok, parent.model.multiplier * parent.type.index_price}
      end)
    end

    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end
end
