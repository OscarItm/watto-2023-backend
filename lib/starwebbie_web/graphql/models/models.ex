defmodule StarwebbieWeb.Models do
  alias Starwebbie.Users
  alias Starwebbie.Items.{Model, Type}
  alias Starwebbie.Items
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :user do
    field :id, non_null(:id)
    field :name, :string
    field :username, non_null(:string)
    field :credits, non_null(:float)
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :user_auth do
    field :token, non_null(:string)
    field :user, :user
  end

  object :type do
    field :id, non_null(:id)
    field :name, :string
    field :index_price, non_null(:integer)
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime

    field :items, list_of(non_null(:item)) do
      resolve(dataloader(Items))
    end
  end

  object :model do
    field :id, non_null(:id)
    field :name, :string
    field :multiplier, non_null(:float)
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime

    field :items, list_of(non_null(:item)) do
      resolve(dataloader(Items))
    end
  end

  object :item do
    field :id, non_null(:id)
    field :name, :string

    field :model, non_null(:model) do
      resolve(dataloader(Starwebbie.Items))
    end

    field :type, non_null(:type) do
      resolve(dataloader(Items))
    end

    field :user, non_null(:user) do
      resolve(dataloader(Users))
    end

    field :for_sale, :boolean

    field :price, :float do
      resolve(fn parent, _args, _context ->
        {:ok, parent.model.multiplier * parent.type.index_price}
      end)
    end

    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end
end
