defmodule StarwebbieWeb.Models do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :name, :string
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
  end
  
  object :model do
    field :id, non_null(:id)
    field :name, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

end
