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
  end

  payload_object(:user_auth_payload, :user_auth)
  payload_object(:user_payload, :user)

  mutation do
    import_fields(:type_mutations)
    import_fields(:model_mutations)
    import_fields(:item_mutations)

    field :signup, :user_auth_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(fn _parent, %{username: username, password: password}, %{context: ctx} ->
        dbg(ctx)

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

      resolve(&update_user/3)
      middleware(&build_payload/2)
    end
  end

  defp update_user(_parent, args, _context) do
    Starwebbie.Users.update_user(args)
  end
end
