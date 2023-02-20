defmodule Starwebbie.Users do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Starwebbie.Repo
  alias Starwebbie.Items.Item
  alias Starwebbie.Users.User

  def data() do
    Dataloader.Ecto.new(Starwebbie.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_users!(123)
      %User{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id), do: Repo.get!(User, id)

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %User{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def check_auth(username, password) do
    user =
      from(u in User, where: u.username == ^username)
      |> Repo.one()

    verify_pass(user, password)
  end

  def verify_pass(nil, _password), do: {:error, "user not found"}

  def verify_pass(user, password) do
    case Argon2.verify_pass(password, Map.get(user, :password)) do
      true -> {:ok, user}
      false -> {:error, :user_not_found}
    end
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %User{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_users(%User{} = users, attrs) do
    users
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_credits(user_id, credits) do
    user = get_users!(user_id)
    creditsToSet = user.credits + credits
    update_users(user, %{credits: creditsToSet})
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_users(users)
      {:ok, %User{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users(%User{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{data: %User{}}

  """
  def change_users(%User{} = users, attrs \\ %{}) do
    User.changeset(users, attrs)
  end

  def buy_item(buyer, seller, item) do
    price = item.type.index_price * item.model.multiplier
    negative_price = -price

    if buyer.id != seller.id do
      Ecto.Multi.new()
      |> Ecto.Multi.run(
        :check_credits,
        fn _, _ ->
          if buyer.credits >= price do
            {:ok, :ok}
          else
            {:error, "not enough credits"}
          end
        end
      )
      |> Ecto.Multi.update(
        :update_credits_seller,
        seller |> User.changeset(%{credits: seller.credits + price})
      )
      |> Ecto.Multi.update(
        :update_credits_buyer,
        buyer |> User.changeset(%{credits: buyer.credits + negative_price})
      )
      |> Ecto.Multi.update(
        :move_item,
        item |> Item.changeset(%{user_id: buyer.id, for_sale: false})
      )
      |> Repo.transaction()
    else
      {:error, "you can't buy your own item"}
    end
  end

  def refund(buyer, seller, item) do
    # never give a full refund!!
    price = item.type.index_price * item.model.multiplier * 0.75
    negative_price = -price

    if buyer.id != seller.id do
      Ecto.Multi.new()
      |> Ecto.Multi.run(
        :check_credits,
        fn _, _ ->
          if buyer.credits >= price do
            {:ok, :ok}
          else
            {:error, "not enough credits"}
          end
        end
      )
      |> Ecto.Multi.update(
        :update_credits_seller,
        seller |> User.changeset(%{credits: seller.credits + price})
      )
      |> Ecto.Multi.update(
        :update_credits_buyer,
        buyer |> User.changeset(%{credits: buyer.credits + negative_price})
      )
      |> Ecto.Multi.update(
        :move_item,
        item |> Item.changeset(%{user_id: buyer.id, for_sale: false})
      )
      |> Repo.transaction()
    else
      {:error, "silly watto, you cannot refund to yourself"}
    end
  end
end
