defmodule StarwebbieWeb.Contexts.User do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  object :user_queries do
    field :me, :user do
      middleware(StarwebbieWeb.Authentication)

      resolve(fn _parent, _args, %{context: %{current_user: user}} ->
        {:ok, user}
      end)
    end
  end

  payload_object(:user_auth_payload, :user_auth)
  payload_object(:user_payload, :user)
  payload_object(:transaction_payload, :transaction)

  object :transaction do
    field :buyer, :user
    field :seller, :user
    field :item, :item
  end

  object :user_mutations do
    field :signup, :user_auth_payload do
      arg(:username, :string)
      arg(:password, :string)
      arg(:name, :string)
      arg(:credits, :float)

      resolve(fn _parent, attrs, %{context: ctx} ->
        case Starwebbie.Users.create_users(attrs) do
          {:ok, user} ->
            {:ok, token, _claims} = StarwebbieWeb.Guardian.encode_and_sign(user)
            {:ok, %{user: user, token: token}}

          {:error, changeset} ->
            {:error, changeset}
        end
      end)

      middleware(&build_payload/2)
    end

    field :signin, :user_auth_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(fn _parent, %{username: username, password: password}, _context ->
        case Starwebbie.Users.check_auth(username, password) do
          {:ok, user} ->
            {:ok, token, _claims} = StarwebbieWeb.Guardian.encode_and_sign(user)
            {:ok, %{user: user, token: token}}

          {:error, _} ->
            {:error, "failed to login"}
        end
      end)

      middleware(&build_payload/2)
    end

    @desc "updates credits for a user"
    field :user_credits_update, :user_payload do
      arg(:user_id, :integer)
      arg(:credits, :float)

      resolve(fn _parent, %{user_id: user_id, credits: credits}, _context ->
        case Starwebbie.Users.update_credits(user_id, credits) do
          {:ok, user} ->
            {:ok, user}

          {:error, _} ->
            {:error, "failed to update credits"}
        end
      end)

      middleware(&build_payload/2)
    end

    @desc "Buy an item from a user"
    field :user_buy, :transaction_payload do
      arg(:item_id, :integer)
      middleware(StarwebbieWeb.Authentication)

      resolve(fn _parent, %{item_id: item_id}, %{context: %{current_user: buyer}} ->
        # check if the item exists
        case(Starwebbie.Items.get_item(item_id)) do
          nil ->
            {:error, "Item not found"}

          item ->
            itemToChange = item

            # check if the user exists
            case Starwebbie.Users.get_users!(itemToChange.user_id) do
              nil ->
                {:error, "seller not found"}

              seller ->
                seller = seller

                # buy the item
                case Starwebbie.Users.buy_item(buyer, seller, itemToChange) do
                  {:ok, result} ->
                    {:ok,
                     %{
                       buyer: result.update_credits_buyer,
                       seller: result.update_credits_seller,

                       # result.move_item returns item pre_update so a query is needed to get the updated item
                       item: result.move_item.id |> Starwebbie.Items.get_item()
                     }}

                  {:error, _} ->
                    {:error, "You already own that item"}

                  {:error, _, _, _} ->
                    {:error, "failed to buy item"}
                end
            end
        end
      end)

      middleware(&build_payload/2)
    end

    @desc "Refund an item at a lower price to a user"
    field :refund, :transaction_payload do
      arg(:item_id, :integer)
      middleware(StarwebbieWeb.Authentication)

      resolve(fn _parent, %{item_id: item_id}, _ctx ->
        # check if the item exists
        case(Starwebbie.Items.get_item(item_id)) do
          nil ->
            {:error, "Item not found"}

          item ->
            itemToChange = item

            # check if the user exists
            case Starwebbie.Users.get_users!(itemToChange.user_id) do
              nil ->
                {:error, "seller not found"}

              seller ->
                seller = seller

                # buy the item
                case Starwebbie.Users.refund(
                       Starwebbie.Users.get_users!(1),
                       seller,
                       itemToChange
                     ) do
                  {:ok, result} ->
                    {:ok,
                     %{
                       buyer: result.update_credits_buyer,
                       seller: result.update_credits_seller,

                       # result.move_item returns item pre_update so a query is needed to get the updated item
                       item: result.move_item.id |> Starwebbie.Items.get_item()
                     }}

                  {:error, _} ->
                    {:error, "You already own that item"}

                  {:error, _, _, _} ->
                    {:error, "failed to buy item"}
                end
            end
        end
      end)

      middleware(&build_payload/2)
    end
  end
end
