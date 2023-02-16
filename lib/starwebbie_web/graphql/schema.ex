defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema
  import AbsintheErrorPayload.Payload

  import_types(StarwebbieWeb.Models)

  import_types(StarwebbieWeb.Contexts.Type)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(StarwebbieWeb.Contexts.Type)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(StarwebbieWeb.Contexts.Model)
  import_types(StarwebbieWeb.Contexts.Item)

  query do
    import_fields(:type_queries)
    import_fields(:model_queries)
    import_fields(:item_queries)

    field :hello, :string do
      arg(:name, :string)

      resolve(fn %{name: name}, _ ->
        {:ok, "Hello #{name}"}
      end)
    end

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

  mutation do
    import_fields(:type_mutations)
    import_fields(:model_mutations)
    import_fields(:item_mutations)

    field :signup, :user_auth_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(fn _parent, %{username: username, password: password}, %{context: ctx} ->
        case Starwebbie.Users.create_users(%{username: username, password: password}) do
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

      resolve(fn
        _parent, %{item_id: item_id}, %{context: %{current_user: buyer}} ->
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

                  case Starwebbie.Users.buy_item(buyer, seller, itemToChange) do
                    {:ok, _} ->
                      {:ok, %{buyer: buyer, seller: seller, item: itemToChange}}

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
